function close_port_process() {
  local port=$1
  local code=${2:-9}
  lsof -i :${port} | awk '{ print $2; }' | xargs kill -${code}
}
