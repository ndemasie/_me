#!/usr/bin/env bash

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
    $'\033[A') echo UP;;
    $'\033[B') echo DOWN;;
    $'\033[D') echo FORWARD;;
    $'\033[C') echo BACK;;

    $'\033[2~') echo INSERT;;
    $'\033[3~') echo DELETE;;
    $'\033[5~') echo PAGE_UP;;
    $'\033[6~') echo PAGE_DOWN;;
    $'\033[7~') echo HOME;;
    $'\033[8~') echo END;;

    $'\033[11~') echo F1;;
    $'\033[12~') echo F2;;
    $'\033[13~') echo F3;;
    $'\033[14~') echo F4;;
    $'\033[15~') echo F5;;
    # $'\033[16~') echo Fx;;
    $'\033[18~') echo F7;;
    $'\033[17~') echo F6;;
    $'\033[19~') echo F8;;
    $'\033[20~') echo F9;;
    $'\033[21~') echo F10;;
    # $'\033[22~') echo Fy;;
    $'\033[23~') echo F11;;
    $'\033[24~') echo F12;;

    $'\033') echo ESC;;
    $'\0') echo ENTER;;
    $'\177') echo BACKSPACE;;
    $'\40') echo SPACE;;
    $'\033[I') echo TAB;;

    *) echo "$key" ;;
  esac
}

# DEMO
# If script called directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  while true; do
    read_keyboard
  done;
fi