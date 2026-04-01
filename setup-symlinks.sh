#!/usr/bin/env sh

# Dotfiles
ln -s "${HOME}/#me/dotfiles/.bash_profile" "${HOME}/.bash_profile"
ln -s "${HOME}/#me/dotfiles/.zprofile" "${HOME}/.zprofile"
# ln -s "${HOME}/#me/dotfiles/.tmux.conf" "${HOME}/.tmux.conf"

# Rectangle Pro (https://rectangleapp.com/pro)
ln -sf "${HOME}/#me/app/Rectangle/com.knollsoft.Rectangle.plist" "${HOME}/Library/Preferences/com.knollsoft.Rectangle.plist"

# VSCode (https://code.visualstudio.com)
ln -sf "${HOME}/#me/app/VSCode/settings.json" "${HOME}/Library/Application Support/Code/User/settings.json"
ln -sf "${HOME}/#me/app/VSCode/keybindings.json" "${HOME}/Library/Application Support/Code/User/keybindings.json"
ln -sf "${HOME}/#me/app/VSCode/snippets" "${HOME}/Library/Application Support/Code/User/snippets"

# Workflows
ln -s "${HOME}/#me/automator/compress-pdf.workflow" "${HOME}/Library/Services/compress-pdf.workflow"
