#!/usr/bin/env bash

# set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes

# COLORS
readonly C_RESET='\033[0m'
readonly C_BOLD="\033[1m"

readonly C_BLACK="\033[30m"
readonly C_CYAN="\033[36m"
readonly C_GREEN="\033[32m"
readonly C_MAGENTA="\033[35m"
readonly C_RED="\033[31m"
readonly C_WHITE="\033[37m"
readonly C_YELLOW="\033[33m"

readonly C_CYAN_LIGHT="\033[96m"
readonly C_GRAY_LIGHT="\033[97m"
readonly C_RED_LIGHT="\033[91m"
readonly C_YELLOW_LIGHT="\033[93m"

readonly C_BLACK_BG="\033[40m"
readonly C_GREEN_BG="\033[42m"
readonly C_CYAN_LIGHT_BG="\033[106m"
readonly C_YELLOW_LIGHT_BG="\033[103m"
readonly C_MAGENTA_BG="\033[45m"
readonly C_RED_BG="\033[41m"

readonly CLEAR_LINE="\033[K"

# CONSTS
readonly TICKET_NUMBER_LEN=3
readonly GIT_MAIN_BRANCH="master"
# readonly GIT_EXCLUDE_REGEX=".env\.*"
readonly GITMOJI_OPTIONS=(
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

_validate_run() {
  if [[ ! $(uname) == "Darwin" ]]; then
    log --error "Script is only intended for MacOS"
    exit 1
  fi

  if ! command -v git &> /dev/null; then
    log --error "Git is required"
    exit 1
  fi

  inside_git_repo=$(git rev-parse --is-inside-work-tree 2>/dev/null)
  if [[ ! "$inside_git_repo" ]]; then
    log --error "Must be inside a git repo"
    exit 1
  fi
}

# Helper functions
ask_yn() {
  declare GO_UP="\033[A\033[80D"
  declare print_error

  echo >&2
  while true; do
    [[ -n $print_error ]] && log --warn "Invalid input: \"${print_error}\"" >&2 || echo >&2
    printf "%b${C_RESET} (y/n): " "$1" >&2
    read -r -n 1

    case "${REPLY}" in
      y|Y) break ;;
      n|N) break ;;
      *) print_error=$REPLY; printf "${GO_UP}${CLEAR_LINE}" echo >&2;;
    esac
  done

  echo "${REPLY}" | tr '[:upper:]' '[:lower:]' | cat
}

menu() {
  declare FLAG_SEARCH=true
  declare FLAG_PAGINATION=true
  declare PAGE_SIZE=10

  echo >&2

  get_cursor_position() { declare POS; read -sdR -p $'\033[6n' POS; echo $POS | cut -c3-; }
  min() { printf "%s\n" "${@:2}" | sort "$1" | head -n1; }
  max() { printf "%s\n" "${@:2}" | sort "$1" | tail -n1; }
  divide_round_up() { echo $((($1 + $2 - 1) / $2)); }
  divide_round_down() { echo "$(awk "BEGIN {print int($1 / $2)}")"; }
  # TODO: Seems to be and escaping issue where the key must assigned to a value
  # DO: `declare key="$(read_keyboard)"; case "$key" in` ...)
  # DON'T: `case "$(read_keyboard)" in` ...)
  read_keyboard() {
    declare k1
    declare k2
    declare k3
    declare k4
    declare k5

    IFS=''
    read -r -s -n1 k1
    [[ $k1 == $'\033' ]] && read -r -s -n1 k2
    [[ $k2 == [ ]] && read -r -s -n1 k3
    [[ $k3 == [0-9] ]] && read -r -s -n1 k4
    [[ $k4 == [0-9] ]] && read -r -s -n1 k5
    unset IFS

    declare key="${k1:-}${k2:-}${k3:-}${k4:-}${k5:-}"
    case "$key" in
      $'\033[A') echo UP ;;
      $'\033[B') echo DOWN ;;
      $'\033[D') echo LEFT ;;
      $'\033[C') echo RIGHT ;;
      $'\177') echo BACKSPACE ;;
      $'\0') echo ENTER;;
      *) echo "$key" ;;
    esac
  }

  declare OPTIONS=("$@")
  declare PAGE_SIZE=$([[ $FLAG_PAGINATION == true ]] && echo "10" || echo "${#OPTIONS[@]}")
  declare LIST_LEN=$(min -g $PAGE_SIZE ${#OPTIONS[@]})
  declare HEADER_LEN=$([[ $FLAG_SEARCH == true ]] && echo "2" || echo "0")
  declare FOOTER_LEN=$([[ $FLAG_PAGINATION == true ]] && echo "2" || echo "0")
  declare FILL_EMPTY=$({
    declare max
    for opt in "${OPTIONS[@]}"; do
      [[ "${#opt}" -gt "$max" ]] && max="${#opt}"
    done
    printf '%*s' $max
  })
  declare CURSOR_POS=$(get_cursor_position)

  declare selected=0
  declare page=0
  declare search=""
  declare options=()
  for opt in "${OPTIONS[@]}"; do
    options+=("$(echo "$opt" | sed -e 's/  / /g' | tr '[[:upper:]]' '[[:lower:]]')")
  done
  declare options_filtered=()

  get_paged_index() { declare i=$(($page * $PAGE_SIZE + $selected)); [[ "${i}" -lt 0 ]] && echo "0" || echo "$i"; }
  get_selected_option() { echo "${options_filtered[$(get_paged_index)]:-}"; }
  go_to() { printf "\033[$((${CURSOR_POS%;*}+${1:-0}));${2:-0}H" >&2; }
  go_to_search() { go_to 0 "$((9+${#search}))"; }
  print_option() { printf "${CLEAR_LINE}${C_RESET} %s\n" "$1" >&2; }
  print_option_selected() { printf "${C_MAGENTA_BG}  %s%s  ${C_RESET}\n" "$1" "${FILL_EMPTY:${#1}}" >&2; }

  draw() {
    options_filtered=()
    declare lower_search=$(echo $search | tr '[[:upper:]]' '[[:lower:]]')

    for index in "${!OPTIONS[@]}"; do
      if [[ "${options[$index]}" == *${lower_search}* ]]; then
        options_filtered+=("${OPTIONS[$index]}")
      fi
    done

    declare options_len="${#options_filtered[@]}"
    declare visible_count=$(min -g "$options_len" $(($options_len - ($PAGE_SIZE * $page))))

    if [[ $selected -ge $visible_count ]]; then
      selected=$(($visible_count-1))
    fi

    go_to
    if [[ $FLAG_SEARCH == true ]]; then
      printf "${CLEAR_LINE}${C_RESET}%s: %s\n" "Search" "$search" >&2
      printf "${CLEAR_LINE}${C_RESET}\n" >&2
    fi

    for (( i=0; i<$LIST_LEN; i++ )) {
      declare page_i=$(($page * $PAGE_SIZE + $i))
      declare option="${options_filtered[$page_i]:-}"
      if [[ $page_i == $(get_paged_index) ]]; then
        print_option_selected "$option"
      else
        print_option "$option"
      fi
    }

    if [[ $FLAG_PAGINATION == true ]]; then
      printf "${CLEAR_LINE}${C_RESET}\n" >&2
      printf "${CLEAR_LINE}${C_RESET}%s %d-%d / %d\n" \
        "Results:" \
        $(( $PAGE_SIZE * $page + 1 )) \
        $(min -g $(($PAGE_SIZE * ($page+1))) "$options_len") \
        "$options_len" >&2
    fi

    [[ $FLAG_SEARCH == true ]] && go_to_search
  }

  draw
  while true; do
    # NOTE: `read_keyboard` out must be assigned. Inline use has escaping issue.
    declare key=$(read_keyboard)
    case "$key" in
      ENTER)
        declare opt="$(get_selected_option)"
        [[ "$opt" != "" ]] && {
          go_to "$(($HEADER_LEN + ${#options_filtered[@]} + $FOOTER_LEN))" 0
          echo >&2
          echo "$opt"
          return
        }
        ;;
      UP)
        go_to "$(($HEADER_LEN + $selected))"
        print_option "$(get_selected_option)"

        ((selected--))
        [[ "$selected" -lt 0 ]] && selected=$(max -g $(($(min -g "${#options_filtered[@]}" $LIST_LEN) - 1)) 0)

        go_to "$(($HEADER_LEN + $selected))"
        print_option_selected "$(get_selected_option)"
        [ $FLAG_SEARCH == true ] && go_to_search
        ;;
      DOWN)
        go_to "$(($HEADER_LEN + $selected))"
        print_option "$(get_selected_option)"

        ((selected++))
        [[ "$selected" -ge $(min -g "${#options_filtered[@]}" $LIST_LEN) ]] && selected=0

        go_to "$(($HEADER_LEN + $selected))"
        print_option_selected "$(get_selected_option)"
        [[ $FLAG_SEARCH == true ]] && go_to_search
        ;;
      LEFT)
        if [[ $FLAG_PAGINATION == true ]]; then
          ((page--))
          [[ "$page" -lt 0 ]] && page=$(divide_round_down ${#options_filtered[@]} $PAGE_SIZE)
          draw
        fi
        ;;
      RIGHT)
        if [[ $FLAG_PAGINATION == true ]]; then
          ((page++))
          [[ "$page" -gt "$(divide_round_down ${#options_filtered[@]} $PAGE_SIZE)" ]] && page=0
          draw
        fi
        ;;
      BACKSPACE)
        if [[ $FLAG_SEARCH == true && "${#search}" -gt 0 ]]; then
          search="${search:0:((${#search}-1))}"
          draw
        fi
        ;;
      *)
        if [[ $FLAG_SEARCH == true ]]; then
          page=0
          search="${search}${key}"
          draw
        fi
        ;;
    esac
  done
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

  declare TICKET_NUMBER_REGEXP="[0-9]{$(($TICKET_NUMBER_LEN-1)),$TICKET_NUMBER_LEN}"

  declare git_branch=$(git branch --show-current)
  declare ticket_type
  declare ticket_number
  declare ticket_description
  declare branch_name
  declare commit_message

  if [[ ! "${git_branch}" == "${GIT_MAIN_BRANCH}" ]]; then
    log --warn "Not on ${C_GREEN}${GIT_MAIN_BRANCH}${C_RESET} branch"

    declare yn_continue=$(ask_yn "Do you want to continue on ${C_GREEN}${git_branch}${C_RESET}?")
    if [[ "$yn_continue" == "y" ]]; then
      branch_name="${git_branch}"
      ticket_type=$(echo "${git_branch%/*}" | tr '[:lower:]' '[:upper:]')
      ticket_number=$(echo "${git_branch}" | grep -E --only-matching --regexp "$TICKET_NUMBER_REGEXP")
    fi
    echo
  fi

  # Read ticket type
  if [[ -z $ticket_type ]]; then
    gitmoji="$(menu "${GITMOJI_OPTIONS[@]}")"
    ticket_type=${gitmoji##* }
  fi

  # Read ticket number
  while [[ ! "${ticket_number:-}" =~ ^${TICKET_NUMBER_REGEXP}$ ]]; do
    printf "${C_MAGENTA}  %s #${C_RESET}" "${ticket_type}" >&2
    read -r -e -n "$TICKET_NUMBER_LEN"
    ticket_number="${REPLY}"
  done

  # Read ticket description
  if [[ -z $ticket_description ]]; then
    declare top_word="$({ git diff --name-only; git diff --name-only --staged; git ls-files --others --exclude-standard; } \
      | sed -E -e 's/\.[^.]*$//' -E -e 's/\/|-|_/\n/g' \
      | sort \
      | uniq --count \
      | sort --sort=numeric --reverse \
      | head --lines=1 \
      | sed -E -e 's/[0-9 ]//g')"
    top_word="$(tr '[:lower:]' '[:upper:]' <<< ${top_word:0:1})${top_word:1}"

    declare GO_UP="\033[A\033[80D"
    printf "${GO_UP}"
    printf "${C_MAGENTA}  %s #%d: %s - ${C_RESET}" "${ticket_type}" "${ticket_number}" "${top_word}" >&2
    read -r -e
    ticket_description=$(echo "${top_word} - ${REPLY}" | xargs -r)
  fi

  # Compose git info
  if [[ -z $branch_name ]]; then
    branch_name=$(echo "${ticket_type}/${ticket_number}-${ticket_description}" \
      | sed -E -e 's/:|;|,//g' -E -e 's/ -| -|  / /g' -e 's/ +/-/g' \
      | tr '[:upper:]' '[:lower:]' \
    )
  fi

  commit_message="${ticket_type:0:1}$(echo ${ticket_type:1} | tr '[:upper:]' '[:lower:]'): #${ticket_number} - ${ticket_description}"

  echo
  printf "%s ${C_GREEN}%s${C_RESET}\n" "Branch Name:" "${branch_name}"
  printf "%s %s\n" "Commit Message:" "${commit_message}"

  # Confirm
  declare yn_continue=$(ask_yn "Everything look good?")
  echo
  [[ "${yn_continue}" == "n" ]] && exit 0

  log --debug "Skipping git commands while in debug mode" && return 0

  # Checkout branch
  if [[ ! "${git_branch}" == "${branch_name}" ]]; then
    log --trace "Checking out new branch ${C_GREEN}${branch_name}${C_RESET}"
    git checkout -b "${branch_name}"
  fi

  # Stage
  log --trace "Staging changes"
  git add --all

  # Unstage prohibited files
  if [[ -n $GIT_EXCLUDE_REGEX ]]; then
    log --trace "Unstage any exlcude files"
    declare prohibited_files="$(git diff --name-only --staged \
      | grep --regex="${GIT_EXCLUDE_REGEX}" \
      | uniq)"

    if [[ -n "$prohibited_files" ]]; then
      git reset "${prohibited_files}"
      git stash save --include-untracked --message "tmp/${branch_name}" "${prohibited_files}"
    fi
  fi

  # Commit
  log --trace "Committing with message ${C_GREEN}\"${commit_message}\"${C_RESET}"
  git commit --message "${commit_message}"

  # Rebase
  declare yn_rebase=$(ask_yn "Rebase ${C_GREEN}origin/${GIT_MAIN_BRANCH}?")
  if [[ "${yn_rebase}" == "y" ]]; then
    log --info "Rebasing ${C_GREEN}${GIT_MAIN_BRANCH} => ${branch_name}${C_RESET}"
    git rebase origin/${GIT_MAIN_BRANCH} || {
      log --warn "Rebase failed. You will need to resolve the merge conflicts"
      log --warn "$ git rebase origin/${GIT_MAIN_BRANCH}"
      git rebase --abort
      exit 1
    }
  fi

  # Publish
  log --info "Publishing branch ${C_GREEN}${branch_name}${C_RESET}"
  git push origin --set-upstream "${branch_name}"

  # Reapply stash
  if [[ -n $GIT_EXCLUDE_REGEX ]]; then
    git stash list \
      | grep "tmp/${branch_name}" \
      | cut -d ':' -f 1 \
      | head -n1 \
      | xargs -r git stash pop
  fi

  return 0
}

main "$@"