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
    $'\033[A') echo UP ;;
    $'\033[B') echo DOWN ;;
    $'\033[D') echo LEFT ;;
    $'\033[C') echo RIGHT ;;
    $'\177') echo BACKSPACE ;;
    $'\0') echo ENTER;;
    *) echo "$key" ;;
  esac
}


while true; do
  read_keyboard
done;