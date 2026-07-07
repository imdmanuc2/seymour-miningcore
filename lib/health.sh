#!/usr/bin/env bash
set -euo pipefail

smc_health() {
  local miningcore_status postgres_status disk_status console_status os_support overall

  miningcore_status="$(service_status "${MININGCORE_SERVICE}")"
  postgres_status="$(service_status "postgresql")"
  console_status="$(port_status "${LOCAL_CONSOLE_PORT}")"
  os_support="$(supported_os_status)"
  disk_status="healthy"
  overall="healthy"

  if [ "$(df / | awk 'NR==2 {gsub("%", "", $5); print $5}')" -ge 90 ]; then
    disk_status="warning"
    overall="warning"
  fi

  if [ "${postgres_status}" != "running" ]; then
    overall="warning"
  fi

  if [ "${miningcore_status}" = "not-installed" ]; then
    overall="warning"
  fi

  cat <<JSON
{
  "product": "${SMC_PRODUCT}",
  "version": "${SMC_VERSION}",
  "overall": "${overall}",
  "checks": [
    {
      "name": "miningcore-service",
      "status": "${miningcore_status}",
      "message": "Seymour MiningCore service status"
    },
    {
      "name": "postgresql",
      "status": "${postgres_status}",
      "message": "PostgreSQL service status"
    },
    {
      "name": "local-console-port",
      "status": "${console_status}",
      "message": "Local Console/API port ${LOCAL_CONSOLE_PORT}"
    },
    {
      "name": "disk",
      "status": "${disk_status}",
      "message": "Root disk usage check"
    },
    {
      "name": "os-support",
      "status": "${os_support}",
      "message": "Official beta target is Ubuntu 24.04 LTS or Debian 12/13"
    }
  ]
}
JSON
}
