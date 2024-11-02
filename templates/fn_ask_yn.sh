#!/usr/bin/env bash

source "$(dirname "$0")/fn_log.sh"

ask_yn() {
  local GOTO_TOP="\e[2A"
  local CLEAR_LINE="\033[K"
  local C_RESET="\e[0m"
  local print_error
  local REPLY

  while true; do
    echo >&2
    [[ -n $print_error ]] && log --warn "Invalid input: \"${print_error}\"" >&2 || echo >&2
    printf "%b${C_RESET}" "$1" >&2
    read -r -n 1

    case "${REPLY}" in
    y | Y)
      true
      return
      ;;
    n | N)
      false
      return
      ;;
    *)
      print_error=$REPLY
      printf "${GOTO_TOP}${CLEAR_LINE}" echo >&2
      ;;
    esac
  done
}

# DEMO
# If script called directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  ask_yn "Do you want to continue ? "
fi
