#!/usr/bin/env bash

log() {
  local DEBUG=true
  local VERBOSE=true

  local C_RESET="\e[0m"
  local C_WHITE="\e[97m"
  local C_YELLOW="\e[33m"
  local C_BLACK_BG="\e[40m"
  local C_GREEN_BG="\e[42m"
  local C_CYAN_LIGHT_BG="\e[106m"
  local C_YELLOW_LIGHT_BG="\e[103m"
  local C_RED_BG="\e[41m"

  local flag=${1:-}
  [[ $flag = -* ]] && shift

  local message="${1:-}"
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

# DEMO
# If script called directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  log "Default"
  log --debug "Debug"
  log --trace "Trace"
  log --info "Info"
  log --warn "Warn"
  log --error "Error"
fi