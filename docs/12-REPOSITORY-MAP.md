# 12 - REPOSITORY MAP

**Status:** Active\
**Owner:** Seymour MiningCore Team\
**Last Updated:** v0.9.1-alpha

## Purpose

This document describes the organization of the Seymour MiningCore
repository.

It serves as the navigation guide for developers, contributors, and
future AI threads.

------------------------------------------------------------------------

## Top-Level Layout

``` text
seymour-miningcore/
├── api/           REST API
├── bin/           CLI entry points
├── config/        Configuration and licensing
├── docs/          Public documentation
├── lib/           Core shell modules
├── systemd/       Service definitions
├── VERSION        Product version
├── CHANGELOG.md   Project changelog
└── README.md      Repository overview
```

------------------------------------------------------------------------

## Directory Reference

### api/

Contains the Flask REST API, route modules, and API-specific code.

### bin/

Contains executable entry points including the `smc` command-line
interface.

### config/

Configuration files, templates, and licensing configuration.

### docs/

The public documentation set. Start with:

`00-START-HERE.md`

### lib/

Reusable shell libraries that implement the core business logic used by
the CLI.

### systemd/

Systemd unit files used to install and manage Seymour MiningCore
services.

------------------------------------------------------------------------

## Key Files

  File                    Purpose
  ----------------------- ------------------------------------------------
  VERSION                 Single source of truth for the product version
  CHANGELOG.md            User-facing release history
  README.md               Project overview
  docs/00-START-HERE.md   Documentation entry point

------------------------------------------------------------------------

## Development Rules

-   Add new functionality to the appropriate module.
-   Avoid duplicate business logic.
-   Keep CLI and API behavior aligned.
-   Update documentation with every significant feature.

------------------------------------------------------------------------

## Documentation Map

Read in this order:

1.  00-START-HERE.md
2.  01-INSTALL.md
3.  02-FIRST-BOOT.md
4.  03-CLI-REFERENCE.md
5.  04-API.md
6.  05-POOL-MANAGEMENT.md
7.  06-LOCAL-CONSOLE.md
8.  07-NEXUS-INTEGRATION.md
9.  08-LICENSING.md
10. 09-SECURITY.md
11. 10-DATA-MODEL.md
12. 11-SYSTEM-ARCHITECTURE.md
13. 12-REPOSITORY-MAP.md
14. 13-CONTRIBUTING.md
15. 14-ROADMAP.md
