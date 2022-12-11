#!/usr/bin/env bash
readonly C_RESET='\033[0m'
readonly C_MAGENTA_BG="\033[45m"

readonly CLEAR_LINE="\033[K"
readonly GITMOJI=(
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

main() {
  echo
  echo

  go_to() { printf "\033[$((${CURSOR_POS%;*}+${1:-0}));${2:-0}H" >&2; }
  go_to_search() { printf "\033[$((${CURSOR_POS%;*}));$((9+${#search}))H" >&2; }
  min() { printf "%s\n" "${@:2}" | sort "$1" | head -n1; }
  max() { printf "%s\n" "${@:2}" | sort "$1" | tail -n1; }
  round_up() { echo $((($1 + $2 - 1) / $2)); }

  get_cursor_position() {
    exec < /dev/tty
    oldstty=$(stty -g)
    stty raw -echo min 0
    tput u7 > /dev/tty
    IFS=';' read -r -d R -a pos
    stty $oldstty
    row=$((${pos[0]:2}))    # strip off the esc-[
    col=$((${pos[1]} - 1))

    echo "${row};${col}"
  }
  read_keyboard() {
    declare k1
    declare k2
    declare k3
    declare k4
    declare k5

    IFS=''
    read -r -s -n1 k1 2>/dev/null >&2
    [[ $k1 == $'\033' ]] && read -r -s -n1 k2  2>/dev/null >&2
    [[ $k2 == [ ]] && read -r -s -n1 k3  2>/dev/null >&2
    [[ $k3 == [0-9] ]] && read -r -s -n1 k4  2>/dev/null >&2
    [[ $k4 == [0-9] ]] && read -r -s -n1 k5  2>/dev/null >&2
    unset IFS

    declare key="${k1:-}${k2:-}${k3:-}${k4:-}${k5:-}"

    case $key in
      $'\033[A') echo UP ;;
      $'\033[B') echo DOWN ;;
      $'\033[D') echo LEFT ;;
      $'\033[C') echo RIGHT ;;
      $'\177') echo BACKSPACE ;;
      # $'') echo ENTER ;;
      *) echo $key ;;
    esac
  }

  declare OPTIONS=("${GITMOJI[@]}")
  declare PAGE_SIZE=10
  declare LIST_LEN=$(min -g $PAGE_SIZE ${#OPTIONS[@]})
  declare FILL_EMPTY="               "
  declare CURSOR_POS=$(get_cursor_position)
  # declare SAVE_POS=$(printf "\033 7")

  declare selected=0
  declare page=0
  declare page_selected
  declare search=""
  declare lower_search
  declare options=()
  for opt in "${OPTIONS[@]}"; do
    options+=("$(echo "$opt" | sed -e 's/  / /g' | tr '[[:upper:]]' '[[:lower:]]')")
  done
  declare options_filtered=()
  declare options_length


  draw() {
    # declare selected_pos=$((${CURSOR_POS%;*}+${selected}))
    options_filtered=()
    lower_search=$(echo $search | tr '[[:upper:]]' '[[:lower:]]')

    for index in "${!OPTIONS[@]}"; do
      if [[ "${options[$index]}" == *${lower_search}* ]]; then
        options_filtered+=("${OPTIONS[$index]}")
      fi
    done

    options_length="${#options_filtered[@]}"
    declare visible_count=$(min -g "$options_length" $(($options_length - ($PAGE_SIZE * $page))))
    if [[ $selected -ge $visible_count ]]; then
      selected=$(($visible_count-1))
    fi
    page_selected=$(($page * $PAGE_SIZE + $selected))

    go_to 0
    printf "${CLEAR_LINE}${C_RESET}%s: %s\n" "Search" "$search" >&2
    printf "${CLEAR_LINE}${C_RESET}\n" >&2

    for (( i=0; i<$LIST_LEN; i++ )) {
      declare page_i=$(($page * $PAGE_SIZE + $i))
      declare option=${options_filtered[$page_i]}
      if [[ $page_i == $page_selected ]]; then
        printf "${C_MAGENTA_BG}  %s%s  ${C_RESET}\n" "$option" "${FILL_EMPTY:${#option}}" >&2
      else
        printf "${CLEAR_LINE}${C_RESET} %s\n" "$option" >&2
      fi
    }

    printf "${CLEAR_LINE}${C_RESET}\n" >&2
    printf "${CLEAR_LINE}${C_RESET}%s %d-%d / %d\n" \
      "Results:" \
      $(( $PAGE_SIZE * $page + 1 )) \
      $(min -g $(($PAGE_SIZE * ($page+1))) "$options_length") \
      "$options_length" >&2

    go_to_search
  }

  draw
  while true; do
    declare key=$(read_keyboard)
    case $key in
      ENTER)
        echo "${OPTIONS[(($selected))]##* }"
        break
        ;;
      UP)
        declare page_selected=$(($page * $PAGE_SIZE + $selected))
        go_to "$((2+$selected))"
        printf "${CLEAR_LINE}${C_RESET} %s\n" "${options_filtered[$page_selected]}" >&2

        ((selected--))
        [[ "$selected" -lt 0 ]] && selected=$(($LIST_LEN - 1))

        declare page_selected=$(($page * $PAGE_SIZE + $selected))
        declare option="${options_filtered[$page_selected]}"
        go_to "$((2+$selected))"
        printf "${C_MAGENTA_BG}  %s%s  ${C_RESET}\n" "$option" "${FILL_EMPTY:${#option}}" >&2
        go_to_search
        ;;
      DOWN)
        declare page_selected=$(($page * $PAGE_SIZE + $selected))
        go_to "$((2+$selected))"
        printf "${CLEAR_LINE}${C_RESET} %s\n" "${options_filtered[$page_selected]}" >&2

        ((selected++))
        [[ "$selected" -ge $LIST_LEN ]] && selected=0

        declare page_selected=$(($page * $PAGE_SIZE + $selected))
        declare option="${options_filtered[$page_selected]}"
        go_to "$((2+$selected))"
        printf "${C_MAGENTA_BG}  %s%s  ${C_RESET}\n" "$option" "${FILL_EMPTY:${#option}}" >&2
        go_to_search
        ;;
      LEFT)
        ((page--))
        [[ "$page" -lt 0 ]] && page=$(round_up $options_length $PAGE_SIZE)
        draw
        ;;
      RIGHT)
        ((page++))
        [[ "$page" -gt "$(round_up $options_length $PAGE_SIZE)" ]] && page=0
        draw
        ;;
      BACKSPACE)
        [[ ${#search} -gt 0 ]] && search="${search:0:((${#search}-1))}"
        draw
        ;;
      *)
        search="${search}${key}"
        draw
        ;;
    esac
  done
}

main