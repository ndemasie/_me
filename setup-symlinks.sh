#!/usr/bin/env sh

ln -s "${HOME}/_me/dotfiles/.bash_profile" "${HOME}/.bash_profile"
ln -s "${HOME}/_me/dotfiles/.zprofile" "${HOME}/.zprofile"

# App Config
# VSCode
ln -sf "${HOME}/_me/app/VSCode/settings.json" "${HOME}/Library/Application Support/Code/User/settings.json"
ln -sf "${HOME}/_me/app/VSCode/keybindings.json" "${HOME}/Library/Application Support/Code/User/keybindings.json"
ln -sf "${HOME}/_me/app/VSCode/snippets" "${HOME}/Library/Application Support/Code/User/snippets"

# Rectangle
ln -sf "${HOME}/_me/app/Rectangle/com.knollsoft.Rectangle.plist" "${HOME}/Library/Preferences/com.knollsoft.Rectangle.plist"
