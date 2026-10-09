#!/usr/bin/env sh

defaults write -g ApplePressAndHoldEnabled -bool false

defaults write com.apple.PowerChime ChimeOnAllHardware -bool false &&
    killall PowerChime

defaults delete com.apple.Preview.LSSharedFileList RecentDocuments
defaults write com.apple.Preview NSRecentDocumentsLimit 0 
defaults write com.apple.Preview.LSSharedFileList RecentDocuments -dict-add MaxAmount 0

defaults delete org.videolan.vlc recentlyPlayedMedia
defaults delete org.videolan.vlc recentlyPlayedMediaList
