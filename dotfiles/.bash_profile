# Source fns
source "$HOME/_me/alias-jqq.sh"
source "$HOME/_me/fn-close-port-process.sh"
source "$HOME/_me/fn-docker.sh"

# Load all secrets
for secret in $HOME/_me/secrets/.secrets*(.); do
  source $secret;
done

# Add Bun to path
BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Add Python to path
PYTHON_INSTALL=$(python3 -m site --user-base)
export PATH="$PYTHON_INSTALL/bin:$PATH"
