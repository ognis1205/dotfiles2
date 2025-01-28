#!/usr/bin/env bash

. "$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)/setup_utils.sh"

install() {
    if command -v asdf 1>/dev/null 2>&1 ; then
	info "asdf is already installed...\n"
    else
	info "asdf has not been installed. Start installing it here...\n"
	git clone https://github.com/asdf-vm/asdf.git "${HOME}/.asdf" --branch v0.15.0
    fi
}

if_yes_then\
    "Do you want to install asdf?"\
    install
