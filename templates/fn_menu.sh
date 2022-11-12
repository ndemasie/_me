example_menu() {
  draw() {
    printf "$HOME_POS" >&2;
    printf "${CLEAR_LINE}${C_RESET}\n" >&2
    printf "${CLEAR_LINE}${C_RESET} %s\n" "${TICKET_OPTIONS[@]}" >&2;
    printf "${CLEAR_LINE}${C_RESET}\n" >&2

    tput cup $((${CURSOR_POS%;*}+${selected:-0})) 0 >&2 # Go to row
    tput el >&2 # Clear row

    declare FILL_EMPTY="         " >&2
    printf "${C_MAGENTA_BG}  %s%s  ${C_RESET}" "${TICKET_OPTIONS[$selected]}" "${FILL_EMPTY:${#TICKET_OPTIONS[$selected]}}" >&2
  }

  selected=0
  # Read ticket type
  while [[ -z $t_type ]]; do
    draw
    read -s -n3 key 2>/dev/null >&2
    case $key in
      # Enter
      "")
        t_type="${TICKET_OPTIONS[(($selected))]##* }"
        ;;
      # Up
      "${ESC}[A")
        ((selected--))
        [[ "$selected" -lt 0 ]] && selected=$((${#TICKET_OPTIONS[@]} - 1))
        ;;
      # Down
      "${ESC}[B")
        ((selected++))
        [[ "$selected" -ge ${#TICKET_OPTIONS[@]} ]] && selected=0
        ;;
      *) ;;
    esac
  done
}