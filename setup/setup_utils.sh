#!/usr/bin/env bash

info() {
    printf "\e[32m[INFO]\e[0m ${*}"
}

if_yes_then() {
    while true; do
        info "${1}" ; read -p " (y/n): " yn
        case "${yn}" in
            [Yy]*) info "Yes\n" ; eval "${@/${1}}" ; break ;;
            [Nn]*) info  "No\n" ; break ;;
            *)     info "Please enter a valid parameter (y/n).\n" ;;
        esac
    done
}
