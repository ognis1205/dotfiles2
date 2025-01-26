#!/usr/bin/env bash

info() {
    printf "\e[32m[INFO]\e[0m ${*}"
}

if [[ $(git secrets 2>/dev/null) = "usage"* ]] ; then
    info "git-secrets is already installed...\n"
else
    info "git-secrets has not been installed. Start installing it here...\n"
    brew install git-secrets
fi
