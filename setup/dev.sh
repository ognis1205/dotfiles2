#!/usr/bin/env bash

. "$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)/include.sh"

install() {
    if command -v just 1>/dev/null 2>&1 ; then
	info "just is already installed...\n"
    else
	info "just has not been installed. Start installing it here...\n"
	brew install just
    fi

    if command -v gh 1>/dev/null 2>&1 ; then
	info "gh is already installed...\n"
    else
	info "gh has not been installed. Start installing it here...\n"
	brew install gh
    fi

    if command -v hatch 1>/dev/null 2>&1 ; then
	info "hatch is already installed...\n"
    else
	info "hatch has not been installed. Start installing it here...\n"
	brew install hatch
    fi

    if command -v protoc 1>/dev/null 2>&1 ; then
	info "protoc is already installed...\n"
    else
	info "protoc has not been installed. Start installing it here...\n"
	brew install protobuf
    fi
}

if_yes_then\
    "Do you want to install developer commands/utilities?"\
    install
