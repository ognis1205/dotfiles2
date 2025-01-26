#!/usr/bin/env bash

info() {
    printf "\e[32m[INFO]\e[0m ${*}"
}

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
