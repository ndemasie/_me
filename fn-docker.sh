#!/usr/bin/env bash

function dclean() {
  docker ps --all --quiet | xargs -r docker rm;
  docker image ls --quiet --filter 'dangling=true' | xargs -r docker rmi;
}

function dfree() {
  docker volume ls --quiet --filter 'dangling=true' | xargs -r docker volume rm;
}

function dstop() {
  docker ps --all --quiet | xargs -r docker stop;
}
