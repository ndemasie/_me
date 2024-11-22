#!/usr/bin/env bash

alias gp="confirm 'git push origin --force' && git push origin --force"
alias gr="confirm 'git rebase origin/main' && git rebase origin/main"

# Delete local branches where remote is :gone
function gprune() {
  # Fetch latest
  git fetch --prune --quiet
  # Force delete 'gone' branchs
  git branch -vv | grep '^[^*].*: gone]' | awk '{print $1}' | xargs git branch -D
}
