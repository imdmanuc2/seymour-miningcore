#!/usr/bin/env bash
set -euo pipefail

license_config_file() {
  echo "${ROOT_DIR}/config/license/license.json"
}

license_default_json() {
  cat <<JSON
{
  "edition": "community",
  "status": "active",
  "licenseId": "COMMUNITY-DEFAULT",
  "licensedTo": "Community User",
  "tags": ["community"],
  "issuedAt": null,
  "expiresAt": null,
  "billing": {
    "mode": "free",
    "subscriptionRequired": false
  },
  "limits": {
    "maxMiners": 3,
    "maxServers": 1,
    "maxPools": null
  },
  "features": {
    "nexusCommandCenter": true,
    "localConsole": true,
    "api": true,
    "graph": true,
    "alerts": true,
    "ai": true,
    "allowPrerelease": false,
    "allFeatures": false
  },
  "developerFee": {
    "required": true,
    "percent": 0.75,
    "status": "active"
  },
  "binding": {
    "serverId": null,
    "required": false
  }
}
JSON
}

smc_license_raw() {
  local file
  file="$(license_config_file)"

  if [[ -f "$file" ]]; then
    jq . "$file"
  else
    license_default_json
  fi
}

smc_license_status() {
  smc_license_raw | jq .
}

smc_license_validate() {
  local license now expires status edition

  license="$(smc_license_raw)"
  now="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

  edition="$(echo "$license" | jq -r '.edition // "unknown"')"
  status="$(echo "$license" | jq -r '.status // "unknown"')"
  expires="$(echo "$license" | jq -r '.expiresAt // empty')"

  valid=true
  reason="License is active."

  if [[ "$status" != "active" ]]; then
    valid=false
    reason="License status is not active."
  fi

  if [[ -n "$expires" ]]; then
    if [[ "$expires" < "$now" ]]; then
      valid=false
      reason="License has expired."
    fi
  fi

  echo "$license" | jq \
    --argjson valid "$valid" \
    --arg reason "$reason" \
    --arg checkedAt "$now" \
    '. + {
      validation: {
        valid: $valid,
        reason: $reason,
        checkedAt: $checkedAt
      }
    }'
}

smc_license_create_beta_template() {
  local now expires
  now="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  expires="$(date -u -d "+90 days" +"%Y-%m-%dT%H:%M:%SZ")"

  cat <<JSON
{
  "edition": "beta",
  "status": "active",
  "licenseId": "BETA-00001",
  "licensedTo": "",
  "contact": "",
  "tags": ["beta"],
  "issuedAt": "${now}",
  "expiresAt": "${expires}",
  "billing": {
    "mode": "free",
    "subscriptionRequired": false
  },
  "limits": {
    "maxMiners": 999999,
    "maxServers": 999,
    "maxPools": null
  },
  "features": {
    "nexusCommandCenter": true,
    "localConsole": true,
    "api": true,
    "graph": true,
    "alerts": true,
    "ai": true,
    "allowPrerelease": true,
    "allFeatures": true
  },
  "developerFee": {
    "required": true,
    "percent": 0.75,
    "status": "active"
  },
  "binding": {
    "serverId": null,
    "required": false
  },
  "notes": "Closed beta evaluation license template."
}
JSON
}

smc_license_command() {
  local action="${1:-status}"

  case "$action" in
    status|show)
      smc_license_status
      ;;
    validate)
      smc_license_validate
      ;;
    create-beta-template)
      smc_license_create_beta_template
      ;;
    *)
      echo "Unknown license command: $action" >&2
      echo "Usage: smc license <status|show|validate|create-beta-template>" >&2
      exit 1
      ;;
  esac
}
