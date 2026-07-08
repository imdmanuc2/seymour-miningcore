#!/usr/bin/env bash
set -euo pipefail

smc_setup_status() {
  local status_json health_json license_json identity_json install_json
  local version hostname ip health install_status identity_exists license_valid next_action

  status_json="$(smc_status)"
  health_json="$(smc_health)"
  license_json="$(smc_license_validate)"
  identity_json="$(smc_identity_status)"
  install_json="$(smc_install_engine_status)"

  version="$(echo "$status_json" | jq -r '.version // "unknown"')"
  hostname="$(echo "$status_json" | jq -r '.system.hostname // "unknown"')"
  ip="$(echo "$status_json" | jq -r '.system.primaryIp // "unknown"')"
  health="$(echo "$health_json" | jq -r '.overall // "unknown"')"
  install_status="$(echo "$install_json" | jq -r '.status // "not-started"')"
  identity_exists="$(echo "$identity_json" | jq -r '.exists // false')"
  license_valid="$(echo "$license_json" | jq -r '.validation.valid // false')"

  next_action="Open Local Console or create first pool."

  if [[ "$install_status" != "complete" ]]; then
    next_action="Run: smc install --yes"
  elif [[ "$identity_exists" != "true" ]]; then
    next_action="Run: smc identity create"
  elif [[ "$license_valid" != "true" ]]; then
    next_action="Fix license before continuing."
  elif [[ "$health" == "unhealthy" ]]; then
    next_action="Run: smc doctor"
  fi

  cat <<JSON
{
  "product": "${SMC_PRODUCT}",
  "version": "${version}",
  "setup": {
    "status": "${install_status}",
    "nextAction": "${next_action}"
  },
  "server": {
    "hostname": "${hostname}",
    "primaryIp": "${ip}"
  },
  "identity": ${identity_json},
  "license": ${license_json},
  "health": ${health_json},
  "install": ${install_json}
}
JSON
}

smc_setup_command() {
  local action="${1:-status}"

  case "$action" in
    status)
      smc_setup_status
      ;;
    *)
      echo "Unknown setup command: $action" >&2
      echo "Usage: smc setup <status>" >&2
      exit 1
      ;;
  esac
}
