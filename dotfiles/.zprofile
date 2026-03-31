## Setup bash completion PATH, MANPATH, etc., for Homebrew.
# eval "$(/opt/homebrew/bin/brew shellenv)"
# source /opt/homebrew/etc/profile.d/bash_completion.sh
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

# Source fns
source "$HOME/#me/templates/fn_confirm.sh"

source "$HOME/#me/fn-close-port-process.sh"
source "$HOME/#me/fn-docker.sh"
source "$HOME/#me/fn-git.sh"
source "$HOME/#me/fn-jqq.sh"

alias gf='
bash "${HOME}/#me/script-gitmoji-commit.sh" \
  --ticket-number-length 2 \
  --menu-setting "--search" \
  --menu-setting "--page=7"
'

# Load all secrets
for secret in $HOME/#me/secrets/.secrets*(.); do
  source "$secret"
done

# Update PATH
PATH="$HOME/.bun/bin:$PATH"              # Bun
# PATH="/usr/local/sbin:$PATH"             # Homebrew /usr/local/sbin
# PATH="$(brew --prefix python)/bin:$PATH" # Python3
