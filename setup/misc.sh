#!/usr/bin/env bash

. "$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)/include.sh"

install() {
    if command -v wget 1>/dev/null 2>&1 ; then
	info "wget is already installed...\n"
    else
	info "wget has not been installed. Start installing it here...\n"
	brew install wget
    fi

    if command -v jq 1>/dev/null 2>&1 ; then
	info "jq is already installed...\n"
    else
	info "jq has not been installed. Start installing it here...\n"
	brew install jq
    fi

    if command -v tmux 1>/dev/null 2>&1 ; then
	info "tmux is already installed...\n"
    else
	info "tmux has not been installed. Start installing it here...\n"
	brew install tmux
    fi

    if command -v tfenv 1>/dev/null 2>&1 ; then
	info "tfenv is already installed...\n"
    else
	info "tfenv has not been installed. Start installing it here...\n"
	brew install tfenv
    fi

    if command -v docker 1>/dev/null 2>&1 ; then
	info "docker is already installed...\n"
    else
	info "docker has not been installed. Start installing it here...\n"
	brew install --cask docker
    fi

    if command -v tree 1>/dev/null 2>&1 ; then
	info "tree is already installed...\n"
    else
	info "tree has not been installed. Start installing it here...\n"
	brew install tree
    fi
}

if_yes_then\
    "Do you want to install useful commands/utilities?"\
    install
