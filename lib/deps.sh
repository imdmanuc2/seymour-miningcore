#!/usr/bin/env bash
set -euo pipefail

smc_deps() {
  dep_status() {
    local name="$1"
    local command="$2"

    if command -v "$command" >/dev/null 2>&1; then
      echo "{\"name\":\"${name}\",\"command\":\"${command}\",\"installed\":true}"
    else
      echo "{\"name\":\"${name}\",\"command\":\"${command}\",\"installed\":false}"
    fi
  }

  cat <<JSON
{
  "dependencies": [
    $(dep_status "Git" "git"),
    $(dep_status "Curl" "curl"),
    $(dep_status "JQ" "jq"),
    $(dep_status "PostgreSQL Client" "psql"),
    $(dep_status "Dotnet" "dotnet"),
    $(dep_status "Nginx" "nginx"),
    $(dep_status "UFW" "ufw"),
    $(dep_status "SS" "ss")
  ]
}
JSON
}
