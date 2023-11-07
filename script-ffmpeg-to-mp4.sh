#!/usr/bin/env bash

dir=$(dirname "${1:-}")
filename=$(basename "${1:-}")
output_file="${filename%.*}.mp4"

if command -v ffmpeg &> /dev/null; then
  ffmpeg -i "$dir/$filename" -vcodec h264 -acodec mp2 "$dir/$output_file"
  exit 0
fi

if command -v docker &> /dev/null; then
  docker run --volume $dir:$dir --workdir $dir \
    jrottenberg/ffmpeg -i "$dir/$filename" -vcodec h264 -acodec mp2 "$dir/$output_file"
  exit 0
fi
