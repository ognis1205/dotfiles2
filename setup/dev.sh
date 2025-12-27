#!/usr/bin/env bash

. "$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)/include.sh"

install() {
    if command -v just 1>/dev/null 2>&1 ; then
        info "just is already installed...\n"
    else
        info "just has not been installed. Start installing it here...\n"
        brew install just
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

    if command -v taplo 1>/dev/null 2>&1 ; then
        info "taplo is already installed...\n"
    else
        info "taplo has not been installed. Start installing it here...\n"
        brew install taplo || cargo install taplo-cli --locked
    fi

    if command -v buf 1>/dev/null 2>&1 ; then
        info "buf is already installed...\n"
    else
        info "buf has not been installed. Start installing it here...\n"
        brew install bufbuild/buf/buf
    fi

    if command -v protoc-gen-jsonschema 1>/dev/null 2>&1 ; then
        info "protoc-gen-jsonschema is already installed...\n"
    else
        info "protoc-gen-jsonschema has not been installed. Start installing it here...\n"
	go install github.com/chrusty/protoc-gen-jsonschema/cmd/protoc-gen-jsonschema@latest
    fi
}

if_yes_then\
    "Do you want to install developer commands/utilities?"\
    install
