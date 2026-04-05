#!/usr/bin/env sh

# Install homebrew
if ! command -v brew; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

### SETUP

# brew list bash-completion &>/dev/null || brew install bash-completion
# brew list ffmpeg &>/dev/null || brew install ffmpeg
# brew list gum &>/dev/null || brew install gum
# brew list python3 &>/dev/null || brew install python3 # Not recommended?

## TMUX - https://github.com/tmux/tmux/wiki
# brew list tmux &>/dev/null || brew install tmux
## git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm


### TOOLS

# brew list bbrew &>/dev/null || brew install bbrew
# brew list btop &>/dev/null || brew install btop
# brew list ctop &>/dev/null || brew install ctop
# brew list git &>/dev/null || brew install git
# brew list lazydocker &>/dev/null || brew install lazydocker
# brew list n &>/dev/null || brew install n

# brew list deno &>/dev/null || brew install deno
# brew list go &>/dev/null || brew install go
# brew list node &>/dev/null || brew install node
# brew list typescript &>/dev/null || brew install typescript
# brew list terraform &>/dev/null || brew install terraform

# brew list cloudflared &>/dev/null || brew install cloudflared
# brew list tailscale &>/dev/null || brew install tailscale

### APPS

# brew list appcleaner &>/dev/null || brew install --cask appcleaner
# brew list bitwarden &>/dev/null || brew install --cask bitwarden
# brew list firefox &>/dev/null || brew install --cask firefox
# brew list libreoffice &>/dev/null || brew install --cask libreoffice
# brew list notunes &>/dev/null || brew install --cask notunes
# brew list sameboy &>/dev/null || brew install --cask sameboy
# brew list utm &>/dev/null || brew install --cask utm
# brew list visual-studio-code &>/dev/null || brew install --cask visual-studio-code
# brew list warp &>/dev/null || brew install --cask warp

## APPS - Failing
## brew list brave-browser &>/dev/null || brew install --cask brave-browser
## brew list docker &>/dev/null || brew install --cask docker

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
# brew list raspberry-pi-imager &>/dev/null || brew install --cask raspberry-pi-imager

### EXTENSIONS

## Vimari - https://github.com/televator-apps/vimari - https://github.com/vladdoster/homebrew-formulae
## Vimari is a Safari extension that provides vim style keyboard based navigation.
# brew list vimari &>/dev/null || brew install --cask vladdoster/formulae/vimari
