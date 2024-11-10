## Setup bash completion PATH, MANPATH, etc., for Homebrew.
# eval "$(/opt/homebrew/bin/brew shellenv)"
# source /opt/homebrew/etc/profile.d/bash_completion.sh
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

# Source fns
source "$HOME/_me/templates/fn_confirm.sh"

source "$HOME/_me/fn-close-port-process.sh"
source "$HOME/_me/fn-docker.sh"
source "$HOME/_me/fn-git.sh"
source "$HOME/_me/fn-jqq.sh"

# Load all secrets
for secret in $HOME/_me/secrets/.secrets*(.); do
  source "$secret"
done

# Update PATH
PATH="$HOME/.bun/bin:$PATH"                     # Bun
PATH="$(python3 -m site --user-base)/bin:$PATH" # Python3
