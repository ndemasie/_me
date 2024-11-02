#!/usr/bin/env bash

set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

# FLAGS
DEBUG=false
VERBOSE=false

# Generic Helpers
usage() { :; }
log() {
  declare flag=${1:-}
  [[ $flag = -* ]] && shift

  declare message="${1:-}"
  # If not set, read from stdin
  [[ -z "$message" ]] || [[ "$message" == "-" ]] && read -r -e -d '' message

  case "${flag}" in
  -d | --debug)
    [[ $DEBUG != true ]] && return 1
    printf "${C_RESET}${C_BLACK_BG}${C_YELLOW} %-6s${C_RESET} %b\n" "DEBUG" "$message"
    ;;
  -t | --trace)
    [[ $DEBUG != true && $VERBOSE != true ]] && return 1
    printf "${C_RESET}${C_CYAN_LIGHT_BG}${C_BLACK} %-6s${C_RESET} %b\n" "TRACE" "$message"
    ;;
  -i | --info)
    [[ $DEBUG != true && $VERBOSE != true ]] && return 1
    printf "${C_RESET}${C_GREEN_BG}${C_WHITE} %-6s${C_RESET} %b\n" "INFO" "$message"
    ;;
  -w | --warn)
    printf "${C_RESET}${C_YELLOW_LIGHT_BG}${C_BLACK} %-6s${C_RESET} %b\n" "WARN" "$message"
    ;;
  -e | --error)
    printf "${C_RESET}${C_RED_BG}${C_WHITE} %-6s${C_RESET} %b\n" "ERROR" "$message"
    ;;
  *)
    printf "${C_RESET} %b\n" "$message"
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

_set_args() {
  while [ "${1:-}" != "" ]; do
    case "$1" in
    -d | --debug) DEBUG=true ;;
    -v | --verbose) VERBOSE=true ;;
    -h | --help) usage && exit 0 ;;
    esac
    shift
  done
}

main() {
  # Setup
  trap _cleanup EXIT
  _validate_run
  _set_args "$@"
  clear
  log --debug "Debug enabled"
  log --info "Verbose enabled"

}

main "$@"
