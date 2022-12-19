#!/usr/bin/env bash

example_ask_yn() {
  while true; do
    declare GOTO_TOP="\e[2A"
    declare print_error

    echo >&2
    [[ -n $print_error ]] && log --warn "Invalid input: \"${print_error}\""  >&2 || echo >&2
    printf "%b${C_RESET}" "$1" >&2
    read -r -n 1

    case "${REPLY}" in
      y|Y) break ;;
      n|N) break ;;
      *) print_error=$REPLY; printf "${GOTO_TOP}${CLEAR_LINE}" echo >&2;;
    esac
  done

  echo "${REPLY}" | tr '[:upper:]' '[:lower:]' | cat
}