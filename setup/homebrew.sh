#!/usr/bin/env sh

info() {
    printf "\e[32m[INFO]\e[0m ${*}"
}

if command -v brew 1>/dev/null 2>&1 ; then
    info "Homebrew is already installed...\n" ; return
else
    info "Homebrew has not been installed. Start installing it here...\n"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
info "Ensuring you have the latest Homebrew...\n"
brew update
info "Ensuring your Homebrew directory is writable...\n"
sudo chown -Rf $(whoami) $(brew --prefix)/*
info "Installing Homebrew services...\n"
brew tap homebrew/services
info "Adding Pivotal tap to Homebrew...\n"
brew tap pivotal/tap
info "Upgrading existing brews...\n"
brew upgrade
info "Cleaning up your Homebrew installation...\n"
brew cleanup
