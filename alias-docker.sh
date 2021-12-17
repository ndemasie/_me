alias dclean='$(docker ps --all --quiet | xargs docker rm) && $(docker image ls --quiet --filter 'dangling=true' | xargs docker rmi)'
alias dfree='docker volume ls --quiet --filter 'dangling=true' | xargs docker volume rm'
alias dstop='docker ps --all --quiet | xargs docker stop'