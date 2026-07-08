# 00 - START HERE

**Status:** Active\
**Owner:** Seymour MiningCore Team\
**Last Updated:** v0.9.1-alpha

## Welcome

Welcome to the Seymour MiningCore repository.

This document is the starting point for developers, contributors,
testers, and future AI threads. Read this file first before making
changes.

## Project Overview

Seymour MiningCore is a commercial-ready mining pool platform with:

-   Local Console
-   REST API
-   Nexus Command Center integration
-   Pool management
-   Licensing foundation
-   Infrastructure graph
-   Commercial deployment architecture

## Current Version

-   Version: **v0.9.1-alpha**
-   Release Stage: **Internal Alpha**
-   Branch: **beta-foundation**

## Documentation Order

Read the documentation in this order:

1.  01-INSTALL.md
2.  02-FIRST-BOOT.md
3.  03-CLI-REFERENCE.md
4.  04-API.md
5.  05-POOL-MANAGEMENT.md
6.  06-LOCAL-CONSOLE.md
7.  07-NEXUS-INTEGRATION.md
8.  08-LICENSING.md
9.  09-SECURITY.md
10. 10-DATA-MODEL.md
11. 11-SYSTEM-ARCHITECTURE.md
12. 12-REPOSITORY-MAP.md
13. 13-CONTRIBUTING.md
14. 14-ROADMAP.md

## Development Principles

-   Keep the CLI and REST API aligned.
-   Every feature must have documentation.
-   Every API endpoint must be documented.
-   Every CLI command must be documented.
-   Avoid duplicate documentation.
-   Update CHANGELOG.md for release-worthy changes.

## Repository Layout

-   `bin/` --- CLI
-   `lib/` --- Core shell modules
-   `api/` --- REST API
-   `config/` --- Configuration and licensing
-   `systemd/` --- Services
-   `docs/` --- Public documentation

## Versioning

The `VERSION` file is the single source of truth for the product
version.

## Release Process

1.  Complete development.
2.  Test.
3.  Update documentation.
4.  Update VERSION.
5.  Update CHANGELOG.
6.  Create release notes.
7.  Tag the release.

## For Future AI Threads

Always begin here, then read the document that owns the subsystem you
are modifying. Do not redesign architecture without updating
`11-SYSTEM-ARCHITECTURE.md`.
