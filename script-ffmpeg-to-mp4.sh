#!/usr/bin/env bash

dir=$(dirname "${1:-}")
filename=$(basename "${1:-}")
output_file="${filename%.*}.mp4"

cmd=(-i "$dir/$filename" -vcodec h264 -acodec aac "$dir/$output_file")

if command -v ffmpeg &>/dev/null; then
  ffmpeg "${cmd[@]}"
  exit 0
fi

if command -v /opt/homebrew/bin/ffmpeg &>/dev/null; then
  /opt/homebrew/bin/ffmpeg "${cmd[@]}"
  exit 0
fi

if command -v docker &>/dev/null; then
  docker run --volume $dir:$dir --workdir $dir \
    jrottenberg/ffmpeg "${cmd[@]}"
  exit 0
fi
