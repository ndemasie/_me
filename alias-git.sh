# delete local branches where remote is :gone
alias gprune="git fetch -p && git branch -vv | awk '/: gone]/{print $1}' | xargs git branch -D"
