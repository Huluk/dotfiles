#!/usr/bin/env sh

defaults write -g ApplePressAndHoldEnabled -bool false

defaults write com.apple.PowerChime ChimeOnAllHardware -bool false &&
    killall PowerChime
