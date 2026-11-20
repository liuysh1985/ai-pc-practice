#!/usr/bin/env bash
# Start Qwen3.8-27B (Gufo, :58080) and Qwen3.6-35B-A3B (llama.cpp, :58081) together.
#
# Usage:
#   ./start-two.sh          start both servers and wait until ready
#   ./start-two.sh stop     stop and remove both containers
#   ./start-two.sh logs     follow logs of both services
#   ./start-two.sh status   show container status
set -euo pipefail

cd "$(dirname "$0")"

case "${1:-up}" in
  stop)
    shift
    exec docker compose down "$@"
    ;;
  logs)
    shift
    exec docker compose logs -f "$@"
    ;;
  status)
    exec docker compose ps
    ;;
esac

if [[ -z "${HOME:-}" ]]; then
  echo "error: HOME is not set; compose mounts \$HOME/LLM_Practice/models" >&2
  exit 1
fi

docker compose up -d "$@"

echo
echo "Waiting for servers to become ready (model load can take a few minutes)..."

wait_ready() {
  local name=$1 url=$2 port=$3 i
  for i in $(seq 1 120); do
    if curl -fsS -o /dev/null --max-time 2 "$url" 2>/dev/null; then
      echo "  ✓ $name ready on :$port"
      return 0
    fi
    # bail early if the container already exited
    local state
    state=$(docker compose ps -q "$name" 2>/dev/null \
      | xargs -r docker inspect -f '{{.State.Status}}' 2>/dev/null || true)
    if [[ "$state" == "exited" || "$state" == "dead" ]]; then
      echo "  ✗ $name container $state — check: $0 logs $name" >&2
      return 1
    fi
    sleep 5
  done
  echo "  ! $name not answering /health after 10 min — check: $0 logs $name" >&2
  return 1
}

rc=0
wait_ready gufo-qwen38-27b http://localhost:58080/health 58080 || rc=1
wait_ready llama-qwen36-35b-a3b http://localhost:58081/health 58081 || rc=1

echo
docker compose ps

if [[ $rc -eq 0 ]]; then
  echo
  echo "Both servers up:"
  echo "  Qwen3.8-27B        -> http://$(hostname -I 2>/dev/null | awk '{print $1}' || echo localhost):58080"
  echo "  Qwen3.6-35B-A3B    -> http://$(hostname -I 2>/dev/null | awk '{print $1}' || echo localhost):58081"
  echo "Reminder: the 'llama' provider in opencode.jsonc must point at port 58081."
fi

exit $rc
