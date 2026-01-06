#!/usr/bin/env bash

"$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)/include.sh"

install() {
    if command -v git 1>/dev/null 2>&1 ; then
        info "git is already installed...\n"
    else
        info "git has not been installed. Start installing it here...\n"
        brew install git
    fi

    if command -v gh 1>/dev/null 2>&1 ; then
        info "gh is already installed...\n"
    else
        info "gh has not been installed. Start installing it here...\n"
        brew install gh
    fi

    if command -v git-secrets 1>/dev/null 2>&1 ; then
        info "git-secrets is already installed...\n"
    else
        info "git-secrets has not been installed. Start installing it here...\n"
        brew install git-secrets
    fi

    if command -v commitizen 1>/dev/null 2>&1 ; then
        info "commitizen is already installed...\n"
    else
        info "commitizen has not been installed. Start installing it here...\n"
        brew install commitizen
    fi
}

if_yes_then\
    "Do you want to install git utilities?"\
    install
