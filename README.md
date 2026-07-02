# Seymour MiningCore

ARM64-native solo mining pool software for Raspberry Pi, Umbrel, and Linux.

Seymour MiningCore is a maintained fork of MiningCore focused on simple solo mining, Raspberry Pi support, and Umbrel-friendly deployment.

## Current Focus

Bitcoin Cash solo mining on Raspberry Pi / Umbrel.

## Features

- Native ARM64 Docker build
- Raspberry Pi 4/5 friendly
- Umbrel App Store ready
- Bitcoin Cash solo mining support
- PostgreSQL-backed share and block tracking
- Stratum mining support
- Prometheus metrics API
- Open source under the MIT license

## Status

| Component | Status |
|---|---|
| ARM64 Docker build | Working |
| Bitcoin Cash node integration | Working |
| PostgreSQL integration | Working |
| Umbrel app packaging | In progress |
| MiningCore Web UI | In progress |
| Multi-coin support | Later |

## Docker Image

The ARM64 image is built from this repository.

```bash
ghcr.io/imdmanuc2/seymour-miningcore:arm64
