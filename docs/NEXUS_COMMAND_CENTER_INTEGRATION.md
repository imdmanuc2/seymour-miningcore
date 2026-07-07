# Nexus Command Center Integration

This document is the integration contract between Seymour MiningCore and Nexus Command Center.

## Seymour MiningCore Responsibilities

- Mining engine
- Local Console
- REST API
- Health reporting
- Pool management
- Licensing
- Update status

## Nexus Responsibilities

- Discover MiningCore servers
- Register servers
- Monitor health
- Install new pools
- Add coins
- Manage fleets
- Display infrastructure

## Future Flow

1. Install Seymour MiningCore
2. Register with Nexus
3. Nexus polls REST API
4. Nexus manages pools and configuration
