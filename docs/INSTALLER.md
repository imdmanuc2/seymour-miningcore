# INSTALLER

**Project:** Seymour MiningCore\
**Version:** 0.9.0-alpha

## Purpose

The Seymour MiningCore installer is designed to provide a consistent,
automated deployment experience for both standalone operators and future
Nexus Command Center managed installations.

The installer is intentionally modular and JSON-aware so it can be
driven by automation instead of only interactive shell prompts.

------------------------------------------------------------------------

# Current Capabilities

Implemented today:

-   Operating system detection
-   Supported OS classification
-   Dependency inspection
-   Installation planning
-   JSON output mode
-   Mandatory developer fee disclosure
-   Status reporting integration

Current installer command:

    install.sh

Supported options:

-   `--yes`
-   `--json`

------------------------------------------------------------------------

# Planned Installation Workflow

1.  Detect operating system.
2.  Verify supported platform.
3.  Install required packages.
4.  Install .NET runtime.
5.  Configure PostgreSQL.
6.  Build Seymour MiningCore.
7.  Generate configuration.
8.  Configure systemd service.
9.  Configure Local Console.
10. Run health validation.
11. Complete installation.

------------------------------------------------------------------------

# Supported Platforms

Primary beta targets:

-   Ubuntu 24.04 LTS
-   Debian 12
-   Debian 13

Development platforms may run but are reported as `dev-unsupported`.

------------------------------------------------------------------------

# JSON Mode

The installer supports machine-readable output intended for:

-   Nexus Command Center
-   Automated deployments
-   CI/CD pipelines
-   Future REST automation

JSON output includes:

-   Installer state
-   Success/failure
-   OS information
-   Developer fee
-   Embedded Seymour MiningCore status

------------------------------------------------------------------------

# Future Nexus Integration

The Nexus Command Center will eventually invoke the installer remotely.

Expected workflow:

    Nexus
       │
       ▼
    Installer
       │
    Dependency checks
       │
    Configuration
       │
    Health validation
       │
    Ready for pool deployment

------------------------------------------------------------------------

# Design Principles

-   Repeatable deployments.
-   Automation-first.
-   Safe to rerun.
-   Machine-readable responses.
-   Shared business logic with CLI modules.
-   Minimal manual configuration.
