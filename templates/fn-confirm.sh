#!/usr/bin/env zsh

function confirm() {
  declare GO_LEFT="\033[80D"
  declare RESET="\033[0m"
  declare RED="\033[31m"

  declare prompt="${1:-Continue?} [y/n]: "

  while true; do
    read -k1 "?$prompt" REPLY
    case "${REPLY}" in
      y|Y) echo >&2; return 0 ;;
      n|N) echo >&2; return 1 ;;
      *) printf "      ${RED}%s${RESET}${GO_LEFT}" "Invalid input"
    esac 
  done
}