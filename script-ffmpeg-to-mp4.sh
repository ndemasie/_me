#!/usr/bin/env bash

ffmpeg_cmd=$(which ffmpeg)

command -v $ffmpeg_cmd >/dev/null 2>&1 || { echo "ffmpeg is not installed"; exit 1; }

path="${1:-}"
output_path="${path%.*}.mp4"

$ffmpeg_cmd -i "$path" -vcodec h264 -acodec mp2 "$output_path"