case $ansi in
  $'\033') echo ESC;;
  $'\0') echo ENTER;;
  $'\177') echo BACKSPACE;;
  $'\40') echo SPACE;;

  # CSI (Control Sequence Introducer) sequences
  $'\033[A') echo UP;;
  $'\033[B') echo DOWN;;
  $'\033[D') echo FORWARD;;
  $'\033[C') echo BACK;;

  $'\033[E') echo NEXT_LINE;;
  $'\033[F') echo PREVIOUS_LINE;;
  $'\033[G') echo HORIZONTAL_ABSOLUTE;;
  $'\033[H') echo POSITION;;
  $'\033[I') echo TAB;;
  $'\033[J') echo LINE_FEED;;
  $'\033[L') echo FORM_FEED;;
  $'\033[M') echo CARRIAGE_RETURN;;

  $'\033[J') echo ERASE_IN_DISPLAY;;
  $'\033[K') echo ERASE_LINE;;

  $'\033[5~') echo PAGE_UP;;
  $'\033[6~') echo PAGE_DOWN;;

  $'\033[2~') echo INSERT;;
  $'\033[3~') echo DELETE;;
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
  *) echo $input;;
esac