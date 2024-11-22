#!/usr/bin/env zsh

alias newnm="rm -rf node_modules/ package-lock.json && npm i"

# Update package-lock.json
function newpl() {
  local hasPreCommit=$(if [[ -f .husky/pre-commit ]]; then echo true; else echo false; fi)

  npm install --package-lock-only

  if $hasPreCommit; then
    sed -i.bak 's/^/#/' .husky/pre-commit
  fi

  git add package-lock.json
  git commit -m "chore: update package-lock.json"

  if $hasPreCommit; then
    mv .husky/pre-commit.bak .husky/pre-commit
  fi
}

# This function hijacks the command npm and runs as a pass-through
# If the command is "i" or "install", then it injects --legacy-peer-deps if it's not already present
function npm() {
  readonly C_GREEN="\033[32m"
  readonly C_WHITE="\033[37m"
  readonly C_GREEN_BG="\033[42m"
  readonly C_RESET='\033[0m'

  log() { printf "${C_GREEN_BG}${C_WHITE} %-6s${C_RESET} %b\n" "INFO" "$@"; }

  declare npm_path=$(which -a npm | grep -E '/usr/.*/npm' | tail -n 1)
  declare npm_cmd=$1
  declare append_args=()
  declare arg_legacy_peer_deps="--legacy-peer-deps"

  if [[ $npm_cmd == 'i' || $npm_cmd == "install" || $npm_cmd == "uninstall" ]] && [[ "$*" != *"${arg_legacy_peer_deps}"* ]]; then
    log "Caught NPM command ${C_GREEN}npm ${*}${C_RESET}"
    log "Appending argument ${C_GREEN}${arg_legacy_peer_deps}${C_RESET}"
    append_args+=("$arg_legacy_peer_deps")
  fi

  declare cmd="$npm_path $* ${append_args[*]}"
  log "Running ${C_GREEN}${cmd}${C_RESET}"
  eval $cmd
}
