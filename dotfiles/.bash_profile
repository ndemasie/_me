## Setup bash completion PATH, MANPATH, etc., for Homebrew.
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

## Source fns
source "$HOME/#me/templates/fn_confirm.sh"

source "$HOME/#me/fn-close-port-process.sh"
source "$HOME/#me/fn-docker.sh"
source "$HOME/#me/fn-git.sh"
source "$HOME/#me/fn-jqq.sh"

## Load all secrets
for secret in $HOME/#me/secrets/.secrets*(.); do
  source "$secret"
done

## Update PATH
PATH="$HOME/.bun/bin:$PATH"                     # Bun
PATH="$(python3 -m site --user-base)/bin:$PATH" # Python3
