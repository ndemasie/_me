#!/usr/bin/env bash

path=${1:-}
output_path="${path%.*}.zip"

zip -r "$output_path" "$path" -x "**/.DS_Store" -x '**/__MACOSX' --junk-paths