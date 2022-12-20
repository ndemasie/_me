#!/usr/bin/env bash

readonly C_RESET='\e[0m'

readonly C_WHITE="\e[97m"
readonly C_YELLOW="\e[33m"

readonly C_BLACK_BG="\e[40m"
readonly C_GREEN_BG="\e[42m"
readonly C_CYAN_LIGHT_BG="\e[106m"
readonly C_GREEN_LIGHT_BG="\e[102m"
readonly C_GRAY_LIGHT_BG="\e[47m"
readonly C_YELLOW_LIGHT_BG="\e[103m"
readonly C_RED_BG="\e[41m"

DEBUG=true
VERBOSE=true

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

log "Default"
log --debug "Debug"
log --trace "Trace"
log --info "Info"
log --warn "Warn"
log --error "Error"