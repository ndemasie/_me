#!/usr/bin/env sh

ln -s "${HOME}/_me/dotfiles/.bash_profile" "${HOME}/.bash_profile"
ln -s "${HOME}/_me/dotfiles/.zprofile" "${HOME}/.zprofile"

# App Config
# VSCode
ln -sf "${HOME}/_me/app/VSCode/settings.json" "${HOME}/Library/Application Support/Code/User/settings.json"
ln -sf "${HOME}/_me/app/VSCode/keybindings.json" "${HOME}/Library/Application Support/Code/User/keybindings.json"
ln -sf "${HOME}/_me/app/VSCode/snippets/handlebars.json" "${HOME}/Library/Application Support/Code/User/snippets/handlebars.json"
ln -sf "${HOME}/_me/app/VSCode/snippets/typescript.json" "${HOME}/Library/Application Support/Code/User/snippets/typescript.json"
ln -sf "${HOME}/_me/app/VSCode/snippets/typescriptreact.json" "${HOME}/Library/Application Support/Code/User/snippets/typescriptreact.json"

# Rectangle