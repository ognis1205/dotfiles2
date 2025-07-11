# ────────────────────────────────
# Prompt setup
# ────────────────────────────────

# Displays the current time in HH:MM format
__render_timestamp() {
    echo "%F{242}%D{%H:%M}%f"
}

# Renders the elapsed time since the last recorded timer as ⧖ HH:MM:SS
__render_duration() {
  local sym="⧖" alt="⧖ --:--:--" col="242"
  [[ -z $__TIMER_RESULT ]] && {
    echo "%F{${col}}${alt}%f"
    return
  }
  local t=${__TIMER_RESULT}
  local h=$(( t / 3600 ))
  local m=$(( (t % 3600) / 60 ))
  local s=$(( t % 60 ))
  local duration=$(printf "%02d:%02d:%02d" $h $m $s)
  col="green"
  (( t >= 30 )) && col="yellow"
  (( t >= 60 )) && col="red"
  echo "%F{${col}}${sym} ${duration}%f"
}

# Displays the power adapter status
__render_power() {
    local sym="⏻" alt="x⏻" col="242" ok=false
    case "$(uname 2>/dev/null)" in
        Darwin*)
            ok=true
            [[ $(pmset -g ac) != *"No adapter attached."* ]] && col="magenta"
            ;;
        Linux*)
            ok=true
            acpi -a 2>/dev/null | grep -q "on-line" && col="magenta"
            ;;
    esac
    ${ok} || { col="red"; sym="${alt}"; }
    echo "%F{${col}}${sym}%f"
}

# Displays Wi-Fi connection status
__render_wifi() {
    local sym="⇆" alt="x⇆" col="242" ok=false
    case "$(uname 2>/dev/null)" in
        Darwin*)
            ok=true
            networksetup -getairportpower en0 | grep -q "On" && col="magenta"
            ;;
        Linux*)
            ok=true
            if command -v nmcli &>/dev/null; then
                nmcli -t -f active,ssid dev wifi 2>/dev/null | grep -q '^yes:' && col="magenta"
            elif command -v iwgetid &>/dev/null; then
                [[ -n $(iwgetid -r) ]] && col="magenta"
            fi
            ;;
    esac
    ${ok} || { col="red"; sym="${alt}"; }
    echo "%F{${col}}${sym}%f"
}

# Displays a visual representation of the current battery level
__render_battery() {
    local sym="⌁" level=1 bar="" percent=0 alt="⌁ □□□□ ---%" col="242" ok=false
    case "$(uname 2>/dev/null)" in
        Darwin*)
            ok=true
            percent=$(pmset -g batt | grep -Eo '\d+%' | head -1 | tr -d '%')
            ;;
        Linux*)
            ok=true
            percent=$(acpi -b 2>/dev/null | grep -Eo '[0-9]+%' | head -1 | tr -d '%')
            ;;
    esac
    if ! $ok || [[ -z "$percent" ]]; then
	echo "%F{red}${alt}%f"
        return
    fi
    (( percent > 50 )) && col="green"
    (( percent > 25 && percent <= 50 )) && col="yellow"
    (( percent <= 25 )) && col="red"
    (( percent > 75 )) && level=4
    (( percent > 50 && percent <= 75 )) && level=3
    (( percent > 25 && percent <= 50 )) && level=2
    for (( i=1; i<=4; i++ )); do
        if (( i <= level )); then
            bar+="■"
        else
            bar+="□"
        fi
    done
    echo "%F{${col}}${sym} ${bar} ${percent}%%%f"
}

# Displays the name of the active Python virtual environment (if any)
__render_venv() {
    local sym="⧉" alt="x⧉" col="242" name="-"
    if [[ -n "${VIRTUAL_ENV}" ]]; then
        name="$(basename "${VIRTUAL_ENV}")" && col="cyan"
    fi
    echo "%F{${col}}${sym} ${name}%f"
}

# Displays the current user and host
__render_user() {
    echo "%F{242}%n@%m%f"
}

# Displays the current user and host
__render_path() {
    echo "%F{242}%~%f"
}

# Displays a subtle vertical bar
__render_vbar() {
    echo "%F{242}⋮%f"
}

# Starts a timer by storing the current EPOCHREALTIME
__start_timer() {
    __TIMER_START=${EPOCHREALTIME}
}

# Stops the timer and computes elapsed time in seconds
__stop_timer() {
    local now=${EPOCHREALTIME}
    if [[ -n $__TIMER_START ]]; then
	__TIMER_RESULT=$(( now - __TIMER_START ))
	unset __TIMER_START
    else
	unset __TIMER_RESULT
    fi
}

# Renders the primary shell prompt (PS1)
__render_prompt() {
    PROMPT=""
    PROMPT+="$(__render_timestamp) "
    PROMPT+="$(__render_vbar) "
    PROMPT+="$(__render_power) "
    PROMPT+="$(__render_wifi) "
    PROMPT+="$(__render_battery) "
    PROMPT+="$(__render_vbar) "
    PROMPT+="$(__render_duration) "
    PROMPT+="$(__render_venv) "
    PROMPT+="$(__render_vbar) "
    PROMPT+="$(__render_user) "
    PROMPT+="$(__render_vbar) "
    PROMPT+="$(__render_path)"
    PROMPT+=$'\n'"%(#.#.$) "
}

# Renders the right-hand side prompt (RPROMPT)
__render_rprompt() {
    LANG=en_US.UTF-8 vcs_info
    RPROMPT="${vcs_info_msg_0_}"
}

# Use 'pure' prompt if available, otherwise fallback to basic VCS-aware prompt
if [ -d "${HOME}/.zsh/pure" ] ; then
    fpath+="${HOME}/.zsh/pure"
    autoload -U promptinit
    promptinit
    prompt pure
else
    autoload -U colors && colors
    autoload -Uz vcs_info
    autoload -Uz add-zsh-hook
    zstyle ':vcs_info:*' formats '%F{green}(%s)-[%b]%f'
    zstyle ':vcs_info:*' actionformats '%F{red}(%s)-[%b|%a]%f'
    add-zsh-hook preexec __start_timer
    add-zsh-hook precmd __stop_timer
    add-zsh-hook precmd __render_prompt
    add-zsh-hook precmd __render_rprompt
fi

# ────────────────────────────────
# Environment variables
# ────────────────────────────────

export EDITOR=/usr/bin/vim # Default editor
export BLOCKSIZE=1k        # Disk block size (e.g. used in df/du)
export LC_ALL=en_US.UTF-8  # Locale setting (override all)
export LANG=en_US.UTF-8    # General locale

# ────────────────────────────────
# Terminal colors (non-macOS)
# ────────────────────────────────

if [ "$(uname 2> /dev/null)" != Darwin ]; then
    export CLICOLOR=1                          # Enable colored output
    export LSCOLORS=ExFxBxDxCxegedabagacad     # Define color scheme for 'ls'
fi

# ────────────────────────────────
# Homebrew paths
# ────────────────────────────────

export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
export HOMEBREW_REPOSITORY="/opt/homebrew"
fpath[1,0]="/opt/homebrew/share/zsh/site-functions" # Add Homebrew site-functions to fpath

# ────────────────────────────────
# PATH setup
# ────────────────────────────────

__path=(
    /opt/homebrew/bin
    /opt/homebrew/sbin
    ${HOME}/.local/bin
    /usr/local/bin
    /usr/local/sbin
    /usr/bin
    /bin
    /usr/sbin
    /sbin
    /System/Cryptexes/App/usr/bin
    /var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin
    /var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin
    /var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin
)
export PATH="${(j|:|)__path}"
unset __path
[ -z "${MANPATH-}" ] || export MANPATH=":${MANPATH#:}"
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"
