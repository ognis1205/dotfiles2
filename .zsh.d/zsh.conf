# ────────────────
# Colors
# ────────────────

autoload -Uz colors
colors

# ────────────────
# History
# ────────────────

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# ────────────────
# Word delimiters
# ────────────────

autoload -Uz select-word-style ; select-word-style default
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecifiedx

# ────────────────
# Completion
# ────────────────

autoload -Uz compinit
compinit

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' ignore-parents parent pwd ..
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'

# ────────────────
# Zsh options
# ────────────────

setopt print_eight_bit
setopt no_beep
setopt no_flow_control
setopt ignore_eof
setopt interactive_comments
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt share_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt extended_glob

# ────────────────
# Keybindings
# ────────────────

bindkey -e
bindkey '^R' history-incremental-pattern-search-backward
