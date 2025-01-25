cd () {
    builtin cd "$@";
    ls -FGlAhp;
}

mcd () {
    mkdir -p "$1" && cd "$1";
}

trash () {
    command mv "$@" ~/.Trash ;
}

ql () {
    qlmanage -p "$*" >& /dev/null;
}

ip () {
    curl http://checkip.amazonaws.com;
}

tx () {
    session="${1}"
    if [ "$session" == "ls" ]; then
        tmux ls
        return
    fi
    if [ ! -z "${TMUX}" ]; then
        tmux switch-client -t "$session"
        return $?
    fi
    tmux ls | grep "^${session}:" -q
    if [ $? -eq 0 ]; then
        tmux attach -t "$session"
    else
        tmux new -s "$session"
    fi
}

tfdestroy () {
    terraform state list | sed "s/.*/'&'/" | xargs -L 1 terraform state rm;
}

elisp () {
    emacs -batch -l "${1}";
}

cached_eval() {
    cache="/tmp/${2}"
    if [[ ! -e "${cache}" ]]; then
        eval "${1}" > "${cache}"
        zcompile "${cache}"
    fi
    source "${cache}"
}
