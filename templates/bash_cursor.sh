# CURSOR
readonly ESC=$(printf "\033")
readonly CLEAR_LINE="\e[K"
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
declare CURSOR_POS=$(get_cursor_position)
declare HOME_POS="\033[${CURSOR_POS}H"