#!/usr/bin/env bash

path=${1:-}
output_path="${path%.*}.zip"

zip -r "$output_path" "$path" --junk-paths -x "**/.DS_Store" -x '**/__MACOSX'