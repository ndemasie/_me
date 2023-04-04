# Source fns
source "$HOME/_me/alias-jqq.sh"
source "$HOME/_me/fn-close-port-process.sh"
source "$HOME/_me/fn-docker.sh"

# Load all secrets
for secret in $HOME/_me/secrets/.secrets*(.); do
  source $secret;
done

# Add Python to path
PATH="$PATH:$(python3 -m site --user-base)/bin"which