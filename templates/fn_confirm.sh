#!/usr/bin/env zsh

function confirm() {
  declare GO_LEFT="\033[80D"
  declare RESET="\033[0m"
  declare RED="\033[31m"
  declare YELLOW="\033[33m"

  declare prompt="${1:-Continue?} [y/n]: "

  while true; do
    printf "${YELLOW}%s${RESET}" "$prompt"
    read -r -n 1
    case "${REPLY}" in
    y | Y)
      echo >&2
      return 0
      ;;
    n | N)
      echo >&2
      return 1
      ;;
    *) printf "      ${RED}%s${RESET}${GO_LEFT}" "Invalid input" ;;
    esac
  done
}

# DEMO
# If script called directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  confirm "git rebase origin/main" && echo "Yes!" || echo "No!"
fi
