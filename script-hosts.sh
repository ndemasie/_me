#!/usr/bin/env zsh

set -o errexit  # abort on nonzero exitstatus
set -o pipefail # don't hide errors within pipes

# Imports
source "$(dirname "$0")/templates/fn_confirm.sh"

# COLORS
declare C_RESET='\033[0m'
declare C_CYAN='\033[36m'
declare C_YELLOW='\033[33m'
declare C_RED='\033[31m'

# CONSTS
declare HOSTS_URL="https://someonewhocares.org/hosts/zero/hosts"
declare UNIX_HOSTS_FILE="/etc/hosts"
declare UNIX_BACKUP_FILE="${UNIX_HOSTS_FILE}.bak"
declare TMP_FILE=""

usage() {
  echo "usage: script-hosts.sh <install|revert> [-h | --help]"
  echo
  echo "  install   download ${HOSTS_URL} and write it to ${UNIX_HOSTS_FILE}"
  echo "            (the current ${UNIX_HOSTS_FILE} is saved to ${UNIX_BACKUP_FILE})"
  echo "  revert    restore ${UNIX_HOSTS_FILE} from ${UNIX_BACKUP_FILE}"
}

_cleanup() {
  [[ -n "$TMP_FILE" && -f "$TMP_FILE" ]] && rm -f "$TMP_FILE"
}

# /etc/hosts, dscacheutil and mDNSResponder are UNIX specific
_require_UNIX() {
  [[ "$(uname -s)" == "Darwin" ]] && return 0

  printf "${C_RED}%s${C_RESET}\n" "This script targets UNIX, but detected: $(uname -s). Aborting."
  exit 1
}

_flush_dns_UNIX() {
  dscacheutil -flushcache
  sudo killall -HUP mDNSResponder
}

_install_UNIX() {
  TMP_FILE="$(mktemp -t hosts)"

  printf "${C_CYAN}%s${C_RESET}\n" "Downloading ${HOSTS_URL}..."
  curl --fail --silent --show-error --location "$HOSTS_URL" --output "$TMP_FILE"
  printf "${C_CYAN}%s${C_RESET}\n" "Downloaded $(wc -l <"$TMP_FILE" | tr -d ' ') lines ($(du -h "$TMP_FILE" | cut -f1))."
  echo

  printf "${C_YELLOW}%s${C_RESET}\n" "The following commands will be run:"
  printf "  %s\n" "sudo cp ${UNIX_HOSTS_FILE} ${UNIX_BACKUP_FILE}"
  printf "  %s\n" "sudo cp ${TMP_FILE} ${UNIX_HOSTS_FILE}"
  printf "  %s\n" "dscacheutil -flushcache"
  printf "  %s\n" "sudo killall -HUP mDNSResponder"
  echo

  confirm "Write ${HOSTS_URL} to ${UNIX_HOSTS_FILE}?" || {
    printf "${C_RED}%s${C_RESET}\n" "Aborted."
    exit 1
  }

  # cp onto the existing file keeps its root:wheel 644 ownership and mode
  sudo cp "$UNIX_HOSTS_FILE" "$UNIX_BACKUP_FILE"
  sudo cp "$TMP_FILE" "$UNIX_HOSTS_FILE"
  _flush_dns_UNIX

  printf "${C_CYAN}%s${C_RESET}\n" "Installed. Previous ${UNIX_HOSTS_FILE} saved at ${UNIX_BACKUP_FILE}"
}

_revert() {
  if [[ ! -f "$UNIX_BACKUP_FILE" ]]; then
    printf "${C_RED}%s${C_RESET}\n" "No backup found at ${UNIX_BACKUP_FILE}. Nothing to revert."
    exit 1
  fi

  printf "${C_YELLOW}%s${C_RESET}\n" "The following commands will be run:"
  printf "  %s\n" "sudo cp ${UNIX_BACKUP_FILE} ${UNIX_HOSTS_FILE}"
  printf "  %s\n" "dscacheutil -flushcache"
  printf "  %s\n" "sudo killall -HUP mDNSResponder"
  echo

  confirm "Restore ${UNIX_HOSTS_FILE} from ${UNIX_BACKUP_FILE}?" || {
    printf "${C_RED}%s${C_RESET}\n" "Aborted."
    exit 1
  }

  sudo cp "$UNIX_BACKUP_FILE" "$UNIX_HOSTS_FILE"
  _flush_dns_UNIX

  printf "${C_CYAN}%s${C_RESET}\n" "Reverted ${UNIX_HOSTS_FILE} from ${UNIX_BACKUP_FILE}"
}

main() {
  trap _cleanup EXIT
  _require_UNIX

  case "${1:-}" in
  install) _install_UNIX ;;
  revert) _revert ;;
  -h | --help) usage ;;
  *) usage && exit 1 ;;
  esac
}

main "$@"
