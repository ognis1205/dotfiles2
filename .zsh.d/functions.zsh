# Changes directory and then lists files with detailed info
cd() {
    builtin cd "${@}"
    ls -FGlAhp
}

# Creates a directory and then changes into it
mcd() {
    if [ -z "${1}" ]; then
        echo "usage: mcd <directory>"
        return 1
    fi
    mkdir -p "${1}" && cd "${1}"
}

# Moves files to macOS Trash
trash() {
    if [ ${#} -eq 0 ]; then
        echo "usage: trash <file(s)>"
        return 1
    fi
    command mv "${@}" "${HOME}/.Trash"
}

# Opens files in QuickLook preview (macOS only)
ql() {
    qlmanage -p "${*}" >& /dev/null
}

# Retrieves and prints the public IP address
ip() {
    curl -fsSL http://checkip.amazonaws.com || echo "failed to get IP"
}

# Helper to manage tmux sessions
# Usage:
#   tx ls          # list sessions
#   tx <session>   # attach to session or create if missing
tx() {
    local session="${1}"
    if [ "${session}" = "ls" ]; then
        tmux ls
        return
    fi
    # If already inside tmux, switch client to target session
    if [ -n "${TMUX}" ]; then
        tmux switch-client -t "${session}"
        return ${?}
    fi
    # Check if session exists
    tmux ls | grep -q "^${session}:"
    if [ ${?} -eq 0 ]; then
        tmux attach -t "${session}"
    else
        tmux new -s "${session}"
    fi
}

# Removes all terraform-managed resources from state (use with caution)
tfdestroy() {
    terraform state list | sed "s/.*/'&'/" | xargs -L 1 terraform state rm
}

# Runs Emacs in batch mode loading the specified elisp file
elisp() {
    emacs -batch -l "${1}"
}

# Evaluates command once and caches output to a file for faster sourcing later
# Usage: cached_eval "<command>" "<cache_filename>"
cached_eval() {
    local cache="/tmp/${2}"
    if [[ ! -e "${cache}" ]]; then
        eval "${1}" > "${cache}"
        zcompile "${cache}"
    fi
    source "${cache}"
}
