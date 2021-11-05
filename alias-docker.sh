alias dstop='docker stop $(docker ps -aq)'
alias dclean='for c in $(docker ps -aq); do docker rm $c; done && for i in $(docker image ls -q -f 'dangling=true'); do docker rmi $i; done'