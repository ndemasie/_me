#!/usr/bin/env sh

# Install homebrew
if ! command -v brew; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# # Setup
# brew list ffmpeg &>/dev/null || brew install ffmpeg
# brew list tmux &>/dev/null || brew install tmux
# brew list python3 &>/dev/null || brew install python3

# # Language specifics
# brew list git &>/dev/null || brew install git
# brew list jq &>/dev/null || brew install jq
# brew list deno &>/dev/null || brew install deno
# brew list node &>/dev/null || brew install node
# brew list typescript &>/dev/null || brew install typescript
# brew list terraform &>/dev/null || brew install terraform

# # App
# brew list rectangle &>/dev/null || brew install --cask rectangle
# brew list maccy &>/dev/null || brew install --cask maccy