#!/usr/bin/env bash
set -euo pipefail

license_config_file() {
  echo "${ROOT_DIR}/config/license/license.json"
}

smc_license_status() {
  local file
  file="$(license_config_file)"

  if [[ ! -f "$file" ]]; then
    cat <<JSON
{
  "edition": "beta-free",
  "status": "active",
  "billing": {
    "mode": "free",
    "subscriptionRequired": false
  },
  "limits": {
    "maxMiners": null,
    "maxPools": null,
    "maxManagedServers": null
  },
  "features": {
    "nexusCommandCenter": true,
    "localConsole": true,
    "api": true,
    "graph": true,
    "alerts": true,
    "ai": true
  },
  "developerFee": {
    "required": true,
    "percent": 0.75,
    "status": "active"
  }
}
JSON
    return
  fi

  jq . "$file"
}

smc_license_command() {
  local action="${1:-status}"

  case "$action" in
    status|show)
      smc_license_status
      ;;
    *)
      echo "Unknown license command: $action" >&2
      echo "Usage: smc license <status|show>" >&2
      exit 1
      ;;
  esac
}
