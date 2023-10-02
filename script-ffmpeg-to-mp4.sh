#!/usr/bin/env bash

ffmpeg_cmd=$(which ffmpeg)

if ! command -v $ffmpeg_cmd &> /dev/null; then
  echo "ffmpeg is not installed"
  exit 1
fi

path="${1:-}"
output_path="${path%.*}.mp4"

$ffmpeg_cmd -i "$path" -vcodec h264 -acodec mp2 "$output_path"