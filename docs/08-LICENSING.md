# 08 - LICENSING

**Status:** Active\
**Owner:** Seymour MiningCore Team\
**Last Updated:** v0.9.1-alpha

## Purpose

This document describes the Seymour MiningCore licensing architecture.

It defines how editions, limits, feature flags, and developer licensing
are represented without exposing commercial implementation details.

------------------------------------------------------------------------

## Design Goals

-   Simple licensing model
-   Feature-based enablement
-   Flexible edition support
-   Future subscription capability
-   Nexus integration
-   Backward compatibility

------------------------------------------------------------------------

## Current Edition

All current alpha installations receive the **beta-free** edition.

Current characteristics:

-   Billing disabled
-   Unlimited miners
-   Unlimited pools
-   Unlimited managed servers
-   All major platform features enabled

The beta-free edition exists to simplify testing while the commercial
licensing platform is under development.

------------------------------------------------------------------------

## License Architecture

A license contains four logical areas:

1.  Identity
2.  Edition
3.  Limits
4.  Features

Typical limits include:

-   Maximum miners
-   Maximum pools
-   Maximum managed servers

Typical feature flags include:

-   REST API
-   Local Console
-   Nexus integration
-   Infrastructure Graph
-   AI features
-   Alerts
-   Marketplace integration

------------------------------------------------------------------------

## Developer Fee

Seymour MiningCore includes a required developer fee.

Current configuration:

-   Required: Yes
-   Percentage: 0.75%

The developer fee is independent of future subscription offerings.

------------------------------------------------------------------------

## Nexus Integration

Nexus Command Center reads license information through the documented
REST API.

This allows Nexus to display:

-   Edition
-   Enabled features
-   Current limits
-   License status

without requiring direct access to local configuration.

------------------------------------------------------------------------

## Future Editions

Future releases may introduce multiple editions with different limits
and feature sets.

Examples include:

-   Starter
-   Hobby
-   Professional
-   Enterprise

Edition definitions are intentionally kept separate from the application
architecture.

------------------------------------------------------------------------

## Security

Licenses should be treated as trusted configuration.

Commercial activation, subscription management, and pricing are
intentionally outside the scope of this public document.

------------------------------------------------------------------------

## Related Documents

-   04-API.md
-   07-NEXUS-INTEGRATION.md
-   09-SECURITY.md
-   11-SYSTEM-ARCHITECTURE.md
