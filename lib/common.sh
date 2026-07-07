#!/usr/bin/env bash
set -euo pipefail

SMC_VERSION="0.9.0-alpha"
SMC_PRODUCT="Seymour MiningCore"
SMC_FEE_PERCENT="0.75"
LOCAL_CONSOLE_PORT="8559"
MININGCORE_SERVICE="seymour-miningcore"

json_escape() {
  printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

primary_ip() {
  hostname -I 2>/dev/null | awk '{print $1}'
}

service_status() {
  local service="$1"
  if systemctl list-unit-files "${service}.service" >/dev/null 2>&1; then
    if systemctl is-active "${service}" >/dev/null 2>&1; then
      echo "running"
    else
      echo "stopped"
    fi
  else
    echo "not-installed"
  fi
}

port_status() {
  local port="$1"
  if ss -ltn 2>/dev/null | awk '{print $4}' | grep -Eq "[:.]${port}$"; then
    echo "open"
  else
    echo "closed"
  fi
}

supported_os_status() {
  local id version
  id="$(. /etc/os-release && echo "$ID")"
  version="$(. /etc/os-release && echo "${VERSION_ID:-unknown}")"

  case "${id}:${version}" in
    ubuntu:24.04|debian:12|debian:13)
      echo "supported"
      ;;
    *)
      echo "dev-unsupported"
      ;;
  esac
}
