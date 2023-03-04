#!/usr/bin/env bash

command -v "/usr/bin/ffmpeg" >/dev/null 2>&1 || { echo "ffmpeg is not installed"; exit 1; }

path="${1:-}"
output_path="${path%.*}.mp4"

/usr/bin/ffmpeg -i "$path" -vcodec h264 -acodec mp2 "$output_path"