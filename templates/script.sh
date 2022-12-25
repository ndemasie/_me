#!/usr/bin/env bash

set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes

# COLORS
readonly C_RESET='\033[0m'

# CONSTS
readonly CONST=42

# FLAGS
declare DEBUG=false
declare VERBOSE=false

# Generic Helpers
usage() {
  echo "usage: gf [-d | --debug ] [-v | --verbose ] [-h | --help]"
}

log() {
  declare flag=${1:-}
  [[ $flag = -* ]] && shift

  declare message="${1:-}"
   # If not set, read from stdin
  [[ -z "$message" || "$message" == "-" ]] && read -r -e -d '' message

  case "${flag}" in
    -d|--debug)
      [[ $DEBUG != true ]] && return 1
      printf "${C_RESET}${C_BLACK_BG}${C_YELLOW} %-6s${C_RESET} %b\n" "DEBUG" "$message"
      ;;
    -t|--trace)
      [[ $DEBUG != true && $VERBOSE != true ]] && return 1
      printf "${C_RESET}${C_CYAN_LIGHT_BG}${C_BLACK} %-6s${C_RESET} %b\n" "TRACE" "$message"
      ;;
    -i|--info)
      [[ $DEBUG != true && $VERBOSE != true ]] && return 1
      printf "${C_RESET}${C_GREEN_BG}${C_WHITE} %-6s${C_RESET} %b\n" "INFO" "$message"
      ;;
    -w|--warn)
      printf "${C_RESET}${C_YELLOW_LIGHT_BG}${C_BLACK} %-6s${C_RESET} %b\n" "WARN" "$message"
      ;;
    -e|--error)
      printf "${C_RESET}${C_RED_BG}${C_WHITE} %-6s${C_RESET} %b\n" "ERROR" "$message"
      ;;
    *)
      printf "${C_RESET} %-6s %b\n" " " "$message"
      ;;
  esac

  return 0
}

# Script layout
_cleanup() {
  echo
  printf "%s\n" "Cleaning up..."
  sleep 0.1
  printf "%s\n" "Exiting..."
}

_set_args(){
  while [ "${1:-}" != "" ]; do
    case "$1" in
      -d|--debug) DEBUG=true ;;
      -v|--verbose) VERBOSE=true ;;
      -h|--help) usage && exit 0 ;;
    esac
    shift
  done
}

# Helper functions


main() {
  # Setup
  trap _cleanup EXIT
  _set_args "$@"
  clear
  [[ $DEBUG == true ]] && log --debug "Debug enabled"
  [[ $VERBOSE == true ]] && log --info "Verbose enabled"
  echo

  # DO SOMETHING
}

main "$@"