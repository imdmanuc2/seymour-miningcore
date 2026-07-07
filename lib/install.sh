#!/usr/bin/env bash
set -euo pipefail

smc_install_plan() {
  cat <<JSON
{
  "supportedOS": "$(supported_os_status)",
  "steps": [
    { "step": 1, "name": "Check Operating System", "status": "pending" },
    { "step": 2, "name": "Install Dependencies", "status": "pending" },
    { "step": 3, "name": "Install .NET Runtime", "status": "pending" },
    { "step": 4, "name": "Configure PostgreSQL", "status": "pending" },
    { "step": 5, "name": "Build Seymour MiningCore", "status": "pending" },
    { "step": 6, "name": "Create systemd Service", "status": "pending" },
    { "step": 7, "name": "Generate Configuration", "status": "pending" },
    { "step": 8, "name": "Run Health Checks", "status": "pending" },
    { "step": 9, "name": "Start Local Console", "status": "pending" },
    { "step": 10, "name": "Installation Complete", "status": "pending" }
  ]
}
JSON
}
