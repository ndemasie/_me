#!/usr/bin/env bash

# https://unix.stackexchange.com/a/216475
# initialize a semaphore with a given number of tokens
open_semaphore(){
    mkfifo pipe-$$
    exec 3<>pipe-$$
    rm pipe-$$
    local i=$1
    for (( ; i>0; i--)); do printf %s 000 >&3; done
}

# run the given command asynchronously and pop/push tokens
run_with_lock(){
    local x
    read -u 3 -n 3 x && ((0==x)) || exit $x
    ( ( "$@"; ); printf '%.3d' $? >&3 ) &
}

# open_semaphore $CONCURRENT_MAX
# for item in "${list[@]}"; do
#     run_with_lock do_something "$item"
# done