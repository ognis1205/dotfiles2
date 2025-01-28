#!/usr/bin/env bash

. "$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)/setup_utils.sh"

setup() {
    info "Setting menu clock...\n"
    info "See 'https://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns'...\n"
    defaults write com.apple.menuextra.clock "DateFormat" 'EEE MMM d  h:mm:ss a'
    killall SystemUIServer

    info "Setting the dock to hide automatically...\n"
    defaults write com.apple.dock autohide -bool true
    killall Dock

    info "Fast key repeat rate, requires reboot to take effect...\n"
    defaults write ~/Library/Preferences/.GlobalPreferences KeyRepeat -int 1
    defaults write ~/Library/Preferences/.GlobalPreferences InitialKeyRepeat -int 15

    info "Setting finder to display full path in title bar...\n"
    defaults write com.apple.finder '_FXShowPosixPathInTitle' -bool true

    info "Stop Photos from opening automatically...\n"
    defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true
}

if_yes_then\
    "Do you want to setup macOS?"\
    setup
