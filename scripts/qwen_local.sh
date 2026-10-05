#!/usr/bin/env zsh
# Load/unload the local Qwen GGUF model served by Hermes' llamacpp router
# gateway (port 18434). Doesn't touch the gateway itself -- only the heavy
# model process (~25GB RAM when loaded).

set -euo pipefail

HERMES_LLAMACPP_DIR="$HOME/.hermes/runtimes/llamacpp"
MODEL_ID="Qwen3.6-35B-A3B-UD-Q4_K_M"
BASE_URL="http://127.0.0.1:18434"

_qwen_api_key() {
  if [[ -f "$HERMES_LLAMACPP_DIR/.api_key" ]]; then
    cat "$HERMES_LLAMACPP_DIR/.api_key"
  else
    echo "Error: API key not found at $HERMES_LLAMACPP_DIR/.api_key" >&2
    exit 1
  fi
}

_qwen_call() {
  local action="$1"
  local key
  key="$(_qwen_api_key)"
  curl -s -X POST "$BASE_URL/models/$action" \
    -H "Authorization: Bearer $key" \
    -H "Content-Type: application/json" \
    -d "{\"model\":\"$MODEL_ID\"}" \
    -w "\nHTTP:%{http_code}\n"
}

_qwen_status() {
  local key
  key="$(_qwen_api_key)"
  curl -s "$BASE_URL/v1/models" -H "Authorization: Bearer $key" \
    | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['data'][0]['status']['value'])" 2>/dev/null || echo "unknown"
}

case "${1:-}" in
  start)
    echo "Loading $MODEL_ID..."
    _qwen_call load
    ;;
  stop)
    echo "Unloading $MODEL_ID..."
    _qwen_call unload
    ;;
  status)
    _qwen_status
    ;;
  *)
    echo "Usage: qwen_local.sh {start|stop|status}" >&2
    exit 1
    ;;
esac
