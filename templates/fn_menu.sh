#!/usr/bin/env bash

menu() {
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

  readonly C_RESET='\033[0m'
  readonly C_MAGENTA_BG="\033[45m"
  readonly CLEAR_LINE="\033[K"

  readonly OPTIONS=("$@")
  readonly PAGE_SIZE=10
  readonly LIST_LEN=$(min -g $PAGE_SIZE ${#OPTIONS[@]})
  readonly HEADER_LEN=2
  readonly FOOTER_LEN=2
  readonly FILL_EMPTY=$({
    declare max
    for opt in "${OPTIONS[@]}"; do
      [[ "${#opt}" -gt "$max" ]] && max="${#opt}"
    done
    printf '%*s' $max
  })
  readonly CURSOR_POS=$(get_cursor_position)

  declare selected=0
  declare page=0
  declare search=""
  declare options=()
  for opt in "${OPTIONS[@]}"; do
    options+=("$(echo "$opt" | sed -e 's/  / /g' | tr '[[:upper:]]' '[[:lower:]]')")
  done
  declare options_filtered=()

  go_to_home() { printf "\033[$((${CURSOR_POS%;*}+${1:-0}));${2:-0}H" >&2; }
  go_to_search() { go_to_home 0 "$((9+${#search}))"; }
  get_paged_index() { echo "$(($page * $PAGE_SIZE + $selected))"; }
  get_selected_option() { echo "${options_filtered[$(get_paged_index)]}"; }
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

    go_to_home 0
    printf "${CLEAR_LINE}${C_RESET}%s: %s\n" "Search" "$search" >&2
    printf "${CLEAR_LINE}${C_RESET}\n" >&2

    for (( i=0; i<$LIST_LEN; i++ )) {
      declare page_i=$(($page * $PAGE_SIZE + $i))
      declare option=${options_filtered[$page_i]}
      if [[ $page_i == $(get_paged_index) ]]; then
        print_option_selected "$option"
      else
        print_option "$option"
      fi
    }

    printf "${CLEAR_LINE}${C_RESET}\n" >&2
    printf "${CLEAR_LINE}${C_RESET}%s %d-%d / %d\n" \
      "Results:" \
      $(( $PAGE_SIZE * $page + 1 )) \
      $(min -g $(($PAGE_SIZE * ($page+1))) "$options_len") \
      "$options_len" >&2

    go_to_search
  }

  draw
  while true; do
    # NOTE: `read_keyboard` out must be assigned. Inline use has escaping issue.
    declare key=$(read_keyboard)
    case "$key" in
      ENTER)
        go_to_home "$(($HEADER_LEN + $LIST_LEN + $FOOTER_LEN))" 0
        echo >&2
        echo "$(get_selected_option)"
        return
        ;;
      UP)
        go_to_home "$(($HEADER_LEN + $selected))"
        print_option "$(get_selected_option)"

        ((selected--))
        [[ "$selected" -lt 0 ]] && selected=$((${#options_filtered[@]} - 1))

        go_to_home "$(($HEADER_LEN + $selected))"
        print_option_selected "$(get_selected_option)"
        go_to_search
        ;;
      DOWN)
        go_to_home "$(($HEADER_LEN + $selected))"
        print_option "$(get_selected_option)"

        ((selected++))
        [[ "$selected" -ge ${#options_filtered[@]} ]] && selected=0

        go_to_home "$(($HEADER_LEN + $selected))"
        print_option_selected "$(get_selected_option)"
        go_to_search
        ;;
      LEFT)
        ((page--))
        [[ "$page" -lt 0 ]] && page=$(divide_round_down ${#options_filtered[@]} $PAGE_SIZE)
        draw
        ;;
      RIGHT)
        ((page++))
        [[ "$page" -gt "$(divide_round_down ${#options_filtered[@]} $PAGE_SIZE)" ]] && page=0
        draw
        ;;
      BACKSPACE)
        [[ ${#search} -gt 0 ]] && search="${search:0:((${#search}-1))}"
        draw
        ;;
      *)
        page=0
        search="${search}${key}"
        draw
        ;;
    esac
  done
}

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

declare item=$(menu "${GITMOJI[@]}")
echo "selected ${item##* }"