#!/usr/bin/env bash
set -euo pipefail

smc_health() {
  local miningcore_status postgres_status disk_status console_status os_support overall
  local pool_validation_status pool_validation_message

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

  pool_validation_status="healthy"
  pool_validation_message="All pool configs are valid"

  if ls "${ROOT_DIR}"/config/pools/*.json >/dev/null 2>&1; then
    for pool_file in "${ROOT_DIR}"/config/pools/*.json; do
      if ! smc_pool_validate "$pool_file" >/dev/null 2>&1; then
        pool_validation_status="unhealthy"
        pool_validation_message="One or more pool configs are invalid"
        overall="warning"
        break
      fi
    done
  else
    pool_validation_status="warning"
    pool_validation_message="No active pool configs found"
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
      "name": "pool-configs",
      "status": "${pool_validation_status}",
      "message": "${pool_validation_message}"
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
