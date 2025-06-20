#!/usr/bin/env bash

. "$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)/include.sh"

install() {
    if command -v duckdb 1>/dev/null 2>&1 ; then
	info "duckdb is already installed...\n"
    else
	info "duckdb has not been installed. Start installing it here...\n"
	curl https://install.duckdb.org | sh
    fi

    if command -v mysql 1>/dev/null 2>&1 ; then
	info "mysql is already installed...\n"
    else
	info "mysql has not been installed. Start installing it here...\n"
	info "SEE: https://github.com/Homebrew/homebrew-core/issues/180498\n"
	brew install mysql-client@8.4
	brew link --overwrite --force mysql@8.4
    fi

    if command -v psql 1>/dev/null 2>&1 ; then
	info "psql is already installed...\n"
    else
	info "psql has not been installed. Start installing it here...\n"
	brew install postgresql@15
	brew link --overwrite --force postgresql@15
    fi
}

if_yes_then\
    "Do you want to install database-related commands/utilities?"\
    install
