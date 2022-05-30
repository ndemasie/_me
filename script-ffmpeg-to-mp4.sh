#!/usr/bin/env sh

command -v "/usr/bin/ffmpeg" >/dev/null 2>&1 || { echo "ffmpeg is not installed"; exit 1; }

$input="$1"

path="$(dirname "$input")"
filename="$(basename "$input")"
file="$(filename%.*)"

/usr/bin/ffmpeg -i "$input" "$path/$file.mp4"