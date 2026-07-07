#!/usr/bin/env bash
set -euo pipefail

smc_doctor() {

    local health deps install_plan status

    health="$(smc_health)"
    deps="$(smc_deps)"
    install_plan="$(smc_install_plan)"
    status="$(smc_status)"

    local supported_os
    supported_os="$(echo "$status" | jq -r '.system.osSupport')"

    local missing_deps
    missing_deps="$(echo "$deps" | jq '[.dependencies[] | select(.installed==false)]')"

    local missing_count
    missing_count="$(echo "$missing_deps" | jq 'length')"

    local disk
    disk="$(echo "$status" | jq '.system.diskUsedPercent')"

    local memory
    memory="$(echo "$status" | jq '.system.memoryUsedPercent')"

    local ready=true

    if [[ "$supported_os" == "unsupported" ]]; then
        ready=false
    fi

    if [[ "$missing_count" != "0" ]]; then
        ready=false
    fi

cat <<JSON
{
  "product":"Seymour MiningCore",
  "readyToInstall":${ready},
  "supportedOS":"${supported_os}",
  "health":$(echo "$health"),
  "dependencies":$(echo "$deps"),
  "missingDependencies":${missing_deps},
  "diskUsedPercent":${disk},
  "memoryUsedPercent":${memory},
  "installPlan":$(echo "$install_plan")
}
JSON

}
