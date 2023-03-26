#!/usr/bin/env bash

function dclean() { docker ps --all --quiet | xargs docker rm && docker image ls --quiet --filter 'dangling=true' | xargs docker rmi; }
function dfree() { docker volume ls --quiet --filter 'dangling=true' | xargs docker volume rm; }
function dstop() { docker ps --all --quiet | xargs docker stop; }