# ────────────────────────────────
# Prompt setup
# ────────────────────────────────

# Displays the power adapter status
__power() {
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
__wifi() {
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
__battery() {
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
    if (( percent > 50 )); then
        col="green"
    elif (( percent > 25 )); then
        col="yellow"
    else
        col="red"
    fi
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
__venv() {
    local sym="⎇" alt="x⎇" col="242" name="-"
    if [[ -n "${VIRTUAL_ENV}" ]]; then
        name="$(basename "${VIRTUAL_ENV}")" && col="cyan"
    fi
    echo "%F{${col}}${sym} ${name}%f"
}

# Renders the primary shell prompt (PS1)
__render_prompt() {
    PROMPT="[$(__power) $(__wifi) $(__battery) $(__venv) %n@%m] %~"$'\n'"%(#.#.$) "
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
