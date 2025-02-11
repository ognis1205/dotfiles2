#!/usr/bin/env bash

. "$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)/include.sh"

install() {
    if [[ $(git secrets 2>/dev/null) = "usage"* ]] ; then
	info "git-secrets is already installed...\n"
    else
	info "git-secrets has not been installed. Start installing it here...\n"
	brew install git-secrets
    fi
}

if_yes_then\
    "Do you want to install git utilities?"\
    install
