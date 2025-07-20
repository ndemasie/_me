#!/usr/bin/env sh

# Install homebrew
if ! command -v brew; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# # SETUP

# brew list bash-completion &>/dev/null || brew install bash-completion
# brew list ffmpeg &>/dev/null || brew install ffmpeg
# brew list gum &>/dev/null || brew install gum
# brew list python3 &>/dev/null || brew install python3 # Not recommended?
# brew list tmux &>/dev/null || brew install tmux

# # TOOLS

# brew list git &>/dev/null || brew install git
# brew list jq &>/dev/null || brew install jq
# brew list deno &>/dev/null || brew install deno
# brew list node &>/dev/null || brew install node
# brew list typescript &>/dev/null || brew install typescript
# brew list terraform &>/dev/null || brew install terraform
# brew list cloudflared &>/dev/null || brew install cloudflared

# # APPS

# brew list warp &>/dev/null || brew install --cask warp

## Rectangle - https://rectangleapp.com/pro
## Superior window management on macOS
# brew list rectangle &>/dev/null || brew install --cask rectangle

## Maccy - https://maccy.app
## Clipboard manager for macOS which does one job - keep your copy history at hand.
# brew list maccy &>/dev/null || brew install --cask maccy

## MonitorControl - https://github.com/MonitorControl/MonitorControl
## Controls your external display brightness and volume and shows native OSD.
# brew list MonitorControl &>/dev/null || brew install --cask MonitorControl

## MenubarX - https://menubarx.app
## A powerful menu bar browser
# brew list menubarx &>/dev/null || brew install --cask menubarx

## Raspberry Pi Imager - https://www.raspberrypi.com/software/
## Imager for PI hobbiests
# brew list raspberry-pi-imager &>/dev/null || brew install --cask raspberry-pi-imager

# # EXTENSIONS

## Vimari - https://github.com/televator-apps/vimari - https://github.com/vladdoster/homebrew-formulae
## Vimari is a Safari extension that provides vim style keyboard based navigation.
# brew list vimari &>/dev/null || brew install --cask vladdoster/formulae/vimari
