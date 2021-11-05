gh() {
  local cmd="${1:-"-h"}"
  local repo="${2:-"${PWD##*/}"}"
  [ -z $2 ] && branch=$(git rev-parse --abbrev-ref HEAD)
  local page=""

  case "$cmd" in
  -b|--branch|--branches) page="branches"
  ;;
  -c|--commit|--commits) page="commits/$branch"
  ;;
  --compare) page="compare"
  ;; 
  -i|--issue|--issues) page="issues"
  ;;
  -o|--open) page="tree/$branch"
  ;;
  -p|--pull|--pulls) page="pulls"
  ;;
  -h|--help)
    echo "gh() options:"
    echo ""
    echo "  -b|--branch|--branches  =>  Go to /branches"
    echo "  -c|--commit|--commits   =>  Go to /commits"
    echo "  --compare               =>  Go to /compare"
    echo "  -i|--issue|--issues     =>  Go to /issues"
    echo "  -o|--open               =>  Go to /tree/:last-branch"
    echo "  -p|--pull|--pulls)      =>  Go to /pulls"
    echo ""
    return 0
  ;;
  esac

  open -a "Firefox" "https://github.com/Stocard/$repo/$page"
};