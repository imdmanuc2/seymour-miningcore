#!/usr/bin/env bash
set -euo pipefail

smc_service_status() {
  local service="${1:-${MININGCORE_SERVICE}}"

  cat <<JSON
{
  "service": "${service}",
  "status": "$(service_status "$service")",
  "requiresSudoForControl": true
}
JSON
}

smc_service_action() {
  local action="${1:-}"
  local service="${2:-${MININGCORE_SERVICE}}"

  if [[ -z "$action" ]]; then
    echo "Usage: smc service <start|stop|restart|status> [service]" >&2
    exit 1
  fi

  case "$action" in
    start|stop|restart)
      if [[ "${EUID}" -ne 0 ]]; then
        cat <<JSON
{
  "success": false,
  "message": "Service control requires sudo.",
  "service": "${service}",
  "action": "${action}",
  "requiresSudo": true
}
JSON
        exit 1
      fi

      systemctl "$action" "$service"

      cat <<JSON
{
  "success": true,
  "message": "Service ${action} completed.",
  "service": "${service}",
  "action": "${action}",
  "status": "$(service_status "$service")"
}
JSON
      ;;

    status)
      smc_service_status "$service"
      ;;

    *)
      echo "Unknown service action: $action" >&2
      exit 1
      ;;
  esac
}
