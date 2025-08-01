#!/usr/bin/env bash

# set -o errexit   # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

# Imports
source "$(dirname "$0")/templates/fn_log.sh"
source "$(dirname "$0")/templates/fn_menu.sh"
source "$(dirname "$0")/templates/fn_ask_yn.sh"

# COLORS
declare C_RESET='\033[0m'
declare C_GREEN="\033[32m"
declare C_MAGENTA="\033[35m"
declare GO_UP="\033[A\033[80D"

# CONSTS
declare TICKET_NUMBER_LEN=3
declare TOP_WORDS_EXCLUDED=("src")
declare GIT_MAIN_BRANCH="main"
declare GIT_EXCLUDE_REGEX=".env\.*"
declare GITMOJI_OPTIONS=()
declare MENU_SETTINGS=()

declare GITMOJI_OPTIONS_DEFAULT=(
  "🐛 BUGFIX"
  "✨ FEATURE"
  "♿️ ACCESSIBILITY"
  "👽️ ALIEN"
  "📈 ANALYTICS"
  "💫 ANIMATION"
  "🏗️  ARCHITECTURE"
  "🛂 AUTHORIZATION"
  "👷 CI"
  "💡 COMMENTS"
  "🔧 CONFIG"
  "🧐 DATA"
  "🗃️  DATABASE"
  "🚀 DEPLOY"
  "⚰️  DEPRECATE"
  "📝 DOCUMENTATION"
  "🚩 FLAG"
  "🩺 HEALTHCHECK"
  "🚑️ HOTFIX"
  "🌐 I18N"
  "🧱 INFRASTRUCTURE"
  "📄 LICENSE"
  "🚨 LINT"
  "🔊 LOGGING"
  "🧵 MULTITHREADING"
  "📦️ PACKAGE"
  "🩹 PATCH"
  "⚡️ PERFORMANCE"
  "♻️  REFACTOR"
  "🔥 REMOVE"
  "🚚 RENAME"
  "📱 RESPONSIVE"
  "🔨 SCRIPT"
  "🔒️ SECURITY"
  "🔍️ SEO"
  "💸 SPONSORSHIP"
  "🎨 STRUCTURE"
  "💄 STYLE"
  "🔖 TAG"
  "🧪 TEST"
  "🏷️  TYPES"
  "✏️  TYPO"
  "🦺 VALIDATION"
  "🚧 WIP"
)

# FLAGS
declare DEBUG=false
declare VERBOSE=false

# Generic Helpers
usage() {
  echo "usage: gf [-d | --debug ] [-v | --verbose ] [-h | --help]"
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
    --ticket-number-length) shift && TICKET_NUMBER_LEN="$1" ;;
    --top-words-excluded) shift && TOP_WORDS_EXCLUDED+=("$1") ;;
    --git-main-branch) shift && GIT_MAIN_BRANCH="$1" ;;
    --git-exclude-regex) shift && GIT_EXCLUDE_REGEX="$1" ;;
    --menu-setting) shift && MENU_SETTINGS+=("$1") ;;
    -o | --option) shift && GITMOJI_OPTIONS+=("$1") ;;
    -d | --debug) DEBUG=true ;;
    -v | --verbose) VERBOSE=true ;;
    -h | --help) usage && exit 0 ;;
    esac
    shift
  done

  if [ "${#GITMOJI_OPTIONS[@]}" -eq 0 ]; then
    GITMOJI_OPTIONS=("${GITMOJI_OPTIONS_DEFAULT[@]}")
  fi
}

_validate_run() {
  if [[ ! $(uname) == "Darwin" ]]; then
    log --error "Script is only intended for MacOS"
    exit 1
  fi

  if ! command -v git &>/dev/null; then
    log --error "Git is required"
    exit 1
  fi

  inside_git_repo=$(git rev-parse --is-inside-work-tree 2>/dev/null)
  if [[ ! "$inside_git_repo" ]]; then
    log --error "Must be inside a git repo"
    exit 1
  fi
}

main() {
  # Setup
  trap _cleanup EXIT
  _validate_run
  _set_args "$@"
  clear
  [[ $DEBUG == true ]] && log --debug "Debug enabled"
  [[ $VERBOSE == true ]] && log --info "Verbose enabled"
  echo

  declare TICKET_NUMBER_REGEXP="[0-9]{$(($TICKET_NUMBER_LEN - 1)),$TICKET_NUMBER_LEN}"
  declare GIT_BRANCH=$(git branch --show-current)

  declare ticket_type
  declare ticket_number
  declare ticket_topic
  declare ticket_title
  # declare ticket_description
  declare branch_name
  declare commit_message

  get_branch_name() {
    echo "${ticket_type}/${ticket_number}-${ticket_topic}-${ticket_title}" |
      sed -E -e 's/:|;|,//g' -E -e 's/ -| -|  / /g' -e 's/ +/-/g' |
      tr '[:upper:]' '[:lower:]'
  }
  get_commit_message() {
    local msg=""
    [[ -n $ticket_type ]] && msg+="${ticket_type}"
    [[ -n $ticket_topic ]] && msg+="(${ticket_topic}): " || msg+=": "
    [[ -n $ticket_number ]] && msg+="#${ticket_number} - "
    [[ -n $ticket_title ]] && msg+="${ticket_title}"
    echo "${msg}" | tr '[:upper:]' '[:lower:]'
  }

  if [[ ! "${GIT_BRANCH}" == "${GIT_MAIN_BRANCH}" ]]; then
    log --warn "Not on ${C_GREEN}${GIT_MAIN_BRANCH}${C_RESET} branch"

    if ask_yn "Do you want to continue on ${C_GREEN}${GIT_BRANCH}${C_RESET}? "; then
      branch_name="${GIT_BRANCH}"
      ticket_type=$(echo "${GIT_BRANCH%/*}")
      ticket_number=$(echo "${GIT_BRANCH}" | grep -E --only-matching --regexp "$TICKET_NUMBER_REGEXP")
    fi
    echo
  fi

  # Read ticket type
  if [[ -z $ticket_type ]]; then
    echo
    declare menu_option="$(menu "${MENU_SETTINGS[@]}" "${GITMOJI_OPTIONS[@]}")"
    ticket_type=$(echo "${menu_option##* }")
  fi

  # Read ticket topic
  if [[ -z $ticket_topic ]]; then
    printf "${GO_UP}"
    printf "${C_MAGENTA}  %s(${C_RESET}" "${ticket_type}" >&2
    read -r -e
    ticket_topic=$(echo "${REPLY}" | xargs -r) # xargs trims whitespace
  fi

  # Read ticket number
  while [[ ! "${ticket_number:-}" =~ ^${TICKET_NUMBER_REGEXP}$ ]]; do
    printf "${GO_UP}"
    printf "${C_MAGENTA}  %s(%s): #${C_RESET}" "${ticket_type}" "${ticket_topic}" >&2
    read -r -e -n "$TICKET_NUMBER_LEN"
    ticket_number="${REPLY}"
  done

  # Read ticket title
  if [[ -z $ticket_title ]]; then
    # declare exclude_words_regexp=$(
    #   local IFS="|"
    #   echo "${TOP_WORDS_EXCLUDED[*]:-}"
    # )
    # declare top_path="$({
    #   git diff --name-only
    #   git diff --name-only --staged
    #   git ls-files --others --exclude-standard
    # } |
    #   cut -d '/' -f 1 |
    #   sed -E -e "s/$exclude_words_regexp\///g" -e 's/\//>/g' |
    #   sort |
    #   uniq --count |
    #   sort --sort=numeric --reverse |
    #   head --lines=1 |
    #   sed -E -e 's/[0-9 ]//g' |
    #   tr '[:upper:]' '[:lower:]')"

    printf "${GO_UP}"
    printf "${C_MAGENTA}  %s(%s): #%d - ${C_RESET}" "${ticket_type}" "${ticket_topic}" "${ticket_number}" >&2
    read -r -e
    ticket_title=$(echo "${REPLY}" | xargs -r) # xargs trims whitespace
  fi

  [[ -z $branch_name ]] && branch_name=$(get_branch_name)
  commit_message=$(get_commit_message)

  echo
  printf "%s ${C_GREEN}%s${C_RESET}\n" "Branch Name:" "${branch_name}"
  printf "%s %s\n" "Commit Message:" "${commit_message}"

  # Confirm
  ask_yn "Everything look good? " || return 1
  echo

  log --debug "Skipping git commands while in debug mode" && return 0

  # Checkout branch
  if [[ ! "${GIT_BRANCH}" == "${branch_name}" ]]; then
    log --trace "Checking out new branch ${C_GREEN}${branch_name}${C_RESET}"
    git checkout -b "${branch_name}"
  fi

  # Stage
  log --trace "Staging changes"
  git add --all

  # Unstage prohibited files
  if [[ -n $GIT_EXCLUDE_REGEX ]]; then
    log --trace "Unstage any exlcude files"
    declare prohibited_files="$(git diff --name-only --staged |
      grep --regex="${GIT_EXCLUDE_REGEX}" |
      uniq)"

    if [[ -n "${prohibited_files}" ]]; then
      echo "${prohibited_files}" | xargs -r git reset
      echo "${prohibited_files}" | xargs -r git stash push --message "tmp/${branch_name}"
    fi
  fi

  # Commit
  log --trace "Committing with message ${C_GREEN}\"${commit_message}\"${C_RESET}"
  git commit --message "${commit_message}"

  # Rebase
  if ask_yn "Rebase ${C_GREEN}origin/${GIT_MAIN_BRANCH}? "; then
    echo
    log --info "Rebasing ${C_GREEN}${GIT_MAIN_BRANCH} => ${branch_name}${C_RESET}"
    git rebase origin/${GIT_MAIN_BRANCH} || {
      log --warn "Rebase failed. You will need to resolve the merge conflicts"
      log --warn "$ git rebase origin/${GIT_MAIN_BRANCH}"
      git rebase --abort
      return 1
    }
  else
    echo
  fi

  # Publish
  log --info "Publishing branch ${C_GREEN}${branch_name}${C_RESET}"
  git push origin --set-upstream "${branch_name}"

  # Reapply stash
  if [[ -n $GIT_EXCLUDE_REGEX ]]; then
    log --trace "Reapplying stash ${C_GREEN}tmp/${branch_name}${C_RESET}"
    git stash list |
      grep "tmp/${branch_name}" |
      cut -d ':' -f 1 |
      head --lines=1 |
      xargs -r git stash pop
  fi

  return 0
}

main "$@"
