# PROJECT_BRIEF

**Project:** Seymour MiningCore\
**Branch:** beta-foundation\
**Current Version:** 0.9.0-alpha

## Executive Summary

Seymour MiningCore is an enhanced MiningCore distribution designed for
both standalone operators and enterprise fleet management through the
Nexus Command Center.

The project extends MiningCore with installation automation, a modular
CLI, health reporting, pool lifecycle management, repository-based
configuration, and future REST APIs.

## Current Milestones

Completed:

-   Modular `smc` CLI
-   Installer framework
-   Dependency detection
-   Health reporting
-   Status reporting
-   Pool repository layer
-   Pool templates (BTC/BCH, Solo/Public)
-   Pool lifecycle:
    -   Create
    -   Validate
    -   List
    -   Enable
    -   Disable
    -   Remove (archive)
    -   Restore
-   Embedded health information inside status output
-   JSON-first automation

## Core Principles

-   Seymour MiningCore is the source of truth.
-   Nexus Command Center consumes exposed interfaces instead of editing
    configuration files.
-   Shared business logic is reused by the CLI, installer, Local
    Console, REST API, and Nexus.
-   Safe operations take priority over destructive actions.

## Current Repository Layout

    bin/
    config/
    docs/
    lib/
    scripts/
    templates/

## Near-Term Beta Goals

1.  Complete installer.
2.  Build Local Console.
3.  Implement REST API.
4.  Integrate with Nexus Command Center.
5.  Add multi-coin deployment workflows.
6.  Publish signed beta releases.

## Long-Term Vision

A complete mining platform supporting:

-   Solo pools
-   Public pools
-   Multi-coin deployments
-   Fleet management
-   Centralized monitoring
-   Automated installation
-   Automated updates
-   Discovery and infrastructure management through Nexus Command Center
