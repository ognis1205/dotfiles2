#!/usr/bin/env bash

. "$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)/include.sh"

install() {
    if command -v just 1>/dev/null 2>&1 ; then
	info "just is already installed...\n"
    else
	info "just has not been installed. Start installing it here...\n"
	brew install just
    fi
}

if_yes_then\
    "Do you want to install developer commands/utilities?"\
    install
