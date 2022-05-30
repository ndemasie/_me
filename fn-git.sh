# delete local branches where remote is :gone
function gprune() {
  git fetch --prune --quiet;
  git branch -vv | grep '^[^*].*: gone]' | awk '{print $1}' | xargs git branch -D;
}
