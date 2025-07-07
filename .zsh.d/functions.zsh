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

# Extracts or mounts archive files based on their file extension.
xf() {
    if [ -f $1 ]; then
        case $1 in
            *.tar.bz2) tar -jxvf "${1}"                    ;;
            *.tar.gz)  tar -zxvf "${1}"                    ;;
            *.bz2)     bunzip2 "${1}"                      ;;
            *.dmg)     hdiutil mount "${1}"                ;;
            *.gz)      gunzip "${1}"                       ;;
            *.tar)     tar -xvf "${1}"                     ;;
            *.tbz2)    tar -jxvf "${1}"                    ;;
            *.tgz)     tar -zxvf "${1}"                    ;;
            *.zip)     unzip "${1}"                        ;;
            *.ZIP)     unzip "${1}"                        ;;
            *.pax)     cat "${1}" | pax -r                 ;;
            *.pax.Z)   uncompress "${1}" --stdout | pax -r ;;
            *.Z)       uncompress "${1}"                   ;;
            *)         echo "'${1}' cannot be extracted/mounted via 'xf'" ;;
        esac
    else
        echo "'${1}' is not a valid file"
    fi
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
