## Setup bash completion PATH, MANPATH, etc., for Homebrew.
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

## Source fns
source "$HOME/_me/templates/fn_confirm.sh"

source "$HOME/_me/fn-close-port-process.sh"
source "$HOME/_me/fn-docker.sh"
source "$HOME/_me/fn-git.sh"
source "$HOME/_me/fn-jqq.sh"

## Load all secrets
for secret in $HOME/_me/secrets/.secrets*(.); do
  source "$secret"
done

## Update PATH
PATH="$HOME/.bun/bin:$PATH"                     # Bun
PATH="$(python3 -m site --user-base)/bin:$PATH" # Python3
