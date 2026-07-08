# 13 - Contributing

**Status:** Active\
**Owner:** Seymour MiningCore Team\
**Last Updated:** v0.9.1-alpha

## Purpose

This document defines the contribution, documentation, and release rules
for Seymour MiningCore.

A feature is not complete until the code is tested, committed, pushed,
and the correct documentation is updated.

## Required Reading

1.  `docs/00-START-HERE.md`
2.  `docs/11-SYSTEM-ARCHITECTURE.md`
3.  The owner document for the subsystem being changed.

## Documentation Ownership

Each topic has one authoritative document.

-   Install → `docs/01-INSTALL.md`
-   First Boot → `docs/02-FIRST-BOOT.md`
-   CLI → `docs/03-CLI-REFERENCE.md`
-   API → `docs/04-API.md`
-   Pools → `docs/05-POOL-MANAGEMENT.md`
-   Local Console → `docs/06-LOCAL-CONSOLE.md`
-   Nexus → `docs/07-NEXUS-INTEGRATION.md`
-   Licensing → `docs/08-LICENSING.md`
-   Security → `docs/09-SECURITY.md`
-   Data Model → `docs/10-DATA-MODEL.md`
-   Architecture → `docs/11-SYSTEM-ARCHITECTURE.md`
-   Repository → `docs/12-REPOSITORY-MAP.md`
-   Roadmap → `docs/14-ROADMAP.md`

Do not duplicate technical information. Link to the owner document
instead.

## Development Workflow

1.  Check branch status.
2.  Implement the change.
3.  Test the change.
4.  Update documentation.
5.  Update `CHANGELOG.md` if appropriate.
6.  Commit and push.

Recommended validation:

``` bash
git status
./bin/smc version
./bin/smc status | jq .
./bin/smc health | jq .
./bin/smc doctor | jq .
curl -s http://127.0.0.1:8560/api/v1/live | jq .
curl -s http://127.0.0.1:8560/api/v1/readiness | jq .
```

## Branch Strategy

-   Primary branch: `beta-foundation`
-   Do not develop directly on `master`
-   Use feature branches for larger work

## Versioning

The `VERSION` file is the single source of truth.

Before every release:

1.  Update `VERSION`
2.  Update `CHANGELOG.md`
3.  Update release notes
4.  Test
5.  Tag the release

## Release Checklist

-   [ ] CLI
-   [ ] REST API
-   [ ] systemd
-   [ ] Doctor
-   [ ] Pools
-   [ ] Licensing
-   [ ] Documentation
-   [ ] Changelog
-   [ ] Version
-   [ ] Repository clean

## Security

Never commit secrets, private keys, production passwords, internal
pricing, or business strategy.

## AI Thread Rules

Every new AI thread should:

1.  Read `00-START-HERE.md`
2.  Read the subsystem owner document.
3.  Keep CLI and API aligned.
4.  Update documentation before considering work complete.
