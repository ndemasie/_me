#!/usr/bin/env sh

# Install homebrew
if ! command -v brew; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# brew list bash-completion &>/dev/null || brew install bash-completion
# brew list ffmpeg &>/dev/null || brew install ffmpeg
# brew list gum &>/dev/null || brew install gum
# brew list python3 &>/dev/null || brew install python3 # Not recommended?
# brew list tmux &>/dev/null || brew install tmux && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# brew list bbrew &>/dev/null || brew install bbrew
# brew list btop &>/dev/null || brew install btop
# brew list ctop &>/dev/null || brew install ctop
# brew list gh &>/dev/null || brew install gh
# brew list git &>/dev/null || brew install git
# brew list lazydocker &>/dev/null || brew install lazydocker
# brew list n &>/dev/null || brew install n
# brew list tree &>/dev/null || brew install tree

# brew list deno &>/dev/null || brew install deno
# brew list go &>/dev/null || brew install go
# brew list node &>/dev/null || brew install node
# brew list typescript &>/dev/null || brew install typescript
# brew list terraform &>/dev/null || brew install terraform

# brew list cloudflared &>/dev/null || brew install cloudflared
# brew list tailscale &>/dev/null || brew install tailscale

# brew list appcleaner &>/dev/null || brew install --cask appcleaner
# brew list bitwarden &>/dev/null || brew install --cask bitwarden
# brew list firefox &>/dev/null || brew install --cask firefox
# brew list libreoffice &>/dev/null || brew install --cask libreoffice
# brew list notunes &>/dev/null || brew install --cask notunes
# brew list sameboy &>/dev/null || brew install --cask sameboy
# brew list utm &>/dev/null || brew install --cask utm
# brew list visual-studio-code &>/dev/null || brew install --cask visual-studio-code
# brew list vlc &>/dev/null || brew install --cask vlc
# brew list warp &>/dev/null || brew install --cask warp

# brew list xykong/tap/flux-markdown &>/dev/null || brew install --cask xykong/tap/flux-markdown
# brew list rectangle &>/dev/null || brew install --cask rectangle
# brew list maccy &>/dev/null || brew install --cask maccy
# brew list MonitorControl &>/dev/null || brew install --cask MonitorControl
# brew list menubarx &>/dev/null || brew install --cask menubarx
# brew list raspberry-pi-imager &>/dev/null || brew install --cask raspberry-pi-imager

# brew list vimari &>/dev/null || brew install --cask vladdoster/formulae/vimari

## FAILING
## brew list brave-browser &>/dev/null || brew install --cask brave-browser
## brew list docker &>/dev/null || brew install --cask docker