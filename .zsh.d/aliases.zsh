# ────────────────────────────────
# Editor / Development
# ────────────────────────────────

alias emacs='/opt/homebrew/bin/emacs'                       # Always use Homebrew Emacs
alias edit='nvim || vim'                                    # Preferred terminal editor
alias g++_includes='g++ -E -x c++ - -v < /dev/null'         # Show G++ include path
alias clang++_includes='clang++ -E -x c++ - -v < /dev/null' # Show Clang++ include path

# ────────────────────────────────
# File operations
# ────────────────────────────────

alias cp='cp -iv'                   # Interactive + verbose copy
alias mv='mv -iv'                   # Interactive + verbose move
alias mkdir='mkdir -pv'             # Create parents, verbose
alias less='less -FSRXc'            # Better less defaults
alias which='type -af'              # Better which
alias path='echo -e ${PATH//:/\\n}' # Print PATH line-by-line

# ────────────────────────────────
# Directory navigation
# ────────────────────────────────

alias cd..='cd ../'              # Fast typo fallback
alias ..='cd ../'                # Up 1 level
alias ...='cd ../../'            # Up 2 level
alias .3='cd ../../../'          # Up 3 level
alias .4='cd ../../../../'       # Up 4 level
alias .5='cd ../../../../../'    # Up 5 level
alias .6='cd ../../../../../../' # Up 6 level
alias ~='cd ${HOME}'             # Home shortcut

# ────────────────────────────────
# Listing
# ────────────────────────────────

alias la='ls -FGlAhp'                         # Long list + hidden files
alias ll='ls -FGlAhp'                         # (same as la — maybe remove one?)
case "$(uname 2> /dev/null)" in
    Darwin*) alias ls='ls -G -F' ;;           # macOS: enable colorized output with -G
    *)       alias ls='ls -F --color=auto' ;; # Others (e.g., Linux): use --color=auto
esac

# ────────────────────────────────
# Tmux helpers
# ────────────────────────────────

alias txk='tmux kill-session -t' # Kill tmux session by name

# ────────────────────────────────
# Misc utilities
# ────────────────────────────────

alias c='clear'                           # Clear screen
alias z='. ${HOME}/.zshrc'                # Reload Zsh configuration
alias show_options='setopt'               # Show Zsh options
alias fix_stty='stty sane'                # Fix terminal if broken
alias cic='set completion-ignore-case On' # Case-insensitive tab-completion

# ────────────────────────────────
# Mac-specific
# ────────────────────────────────

alias f='open -a Finder ./'            # Open current dir in Finder
alias dt='tee ${HOME}/Desktop/tee.txt' # Write output to Desktop

# ────────────────────────────────
# Global aliases (for piping)
# ────────────────────────────────

if [ command -v pbcopy 1>/dev/null 2>&1 ] ; then
    alias -g C='| pbcopy'                          # Pipe to clipboard (macOS)
elif [ command -v xsel 1>/dev/null 2>&1 ] ; then
    alias -g C='| xsel --input --clipboard'        # Pipe to clipboard (Linux/X11)
elif [ command -v putclip >/dev/null 2>&1 ] ; then
    alias -g C='| putclip'                         # Pipe to clipboard (Windows or Cygwin)
fi
