# Seymour MiningCore

**ARM64-native MiningCore for Raspberry Pi, Umbrel and Solo Mining**

> Modern ARM64 MiningCore focused on Bitcoin Cash solo mining with future support for additional SHA256 and Scrypt coins.

---

## Features

- Native ARM64 support
- Raspberry Pi 4/5 optimized
- Umbrel App Store integration
- Bitcoin Cash Solo Mining
- MiningCore Web UI
- PostgreSQL backend
- Prometheus Metrics API
- Stratum mining server
- Docker deployment
- Multi-coin roadmap

---

## Why Seymour MiningCore?

Most MiningCore deployments target traditional x86 servers.

**Seymour MiningCore** is designed specifically for:

- Raspberry Pi 4 & 5
- Umbrel
- Home miners
- Solo mining
- Easy deployment
- Low maintenance

The goal is to make running your own mining pool as simple as installing an Umbrel app.

---

# Current Status

| Component | Status |
|-----------|--------|
| ARM64 Docker Build | ✅ Complete |
| Raspberry Pi Support | ✅ Complete |
| Bitcoin Cash Node | ✅ Complete |
| MiningCore ARM64 | ✅ Complete |
| PostgreSQL Integration | ✅ Complete |
| Umbrel Packaging | 🚧 In Progress |
| MiningCore Web UI | 🚧 In Progress |
| First-run Wizard | Planned |
| BTC Support | Planned |
| DOGE Support | Planned |
| DigiByte Support | Planned |

---

# Quick Start

```text
Install BCH Node
        │
        ▼
Wait for Blockchain Sync
        │
        ▼
Install Seymour MiningCore
        │
        ▼
Enter BCH Wallet Address
        │
        ▼
Start Mining
        │
        ▼
Find a Block 🎉
```

---

# Umbrel Goal

The goal is a clean Umbrel install flow:

1. Install Bitcoin Cash Node
2. Wait for blockchain sync
3. Install Seymour MiningCore
4. Enter BCH payout address
5. Point miners to the pool
6. Start BCH Solo Mining

No command line should be required after installation.

---

# Default Ports

| Service | Port |
|---------|------|
| Stratum | **6001** |
| MiningCore API | **4000** |

---

# Example Miner Configuration

```text
URL:
stratum+tcp://YOUR_UMBREL_IP:6001

Worker:
anything

Password:
x
```

---

# Docker Build

```bash
git clone https://github.com/imdmanuc2/seymour-miningcore.git

cd seymour-miningcore

docker build \
-f Dockerfile.arm64 \
-t seymour/miningcore-arm64 .
```

---

# Roadmap

## Phase 1

- ✅ ARM64 Dockerfile
- ✅ Remove legacy donation banner
- 🚧 GitHub Actions ARM64 build
- 🚧 BCH-only coin template
- 🚧 Umbrel app integration
- 🚧 MiningCore Web UI integration

## Phase 2

- First-run configuration wizard
- Optional transparent developer donation setting
- BTC support
- DOGE support
- DigiByte support
- Additional SHA256 coins

## Phase 3

- One-click Umbrel deployment
- Automatic updates
- Pool templates
- Multi-pool management
- Web-based configuration

---

# Repository Structure

```text
Docker
MiningCore
Umbrel App
MiningCore Web UI
Documentation
```

---

# Documentation

Documentation is currently being written.

Planned guides include:

- Installation Guide
- Umbrel Setup
- Raspberry Pi Setup
- Bitcoin Cash Solo Mining
- Docker Deployment
- API Reference

---

# Contributing

Issues, bug reports, feature requests, and pull requests are welcome.

---

# Credits

Seymour MiningCore is based on the excellent open-source MiningCore project originally created by **Oliver Weichhold**.

This fork focuses on:

- ARM64
- Raspberry Pi
- Umbrel
- Solo mining
- Simplified deployment

while remaining compatible with upstream MiningCore whenever practical.

---

# Repository

https://github.com/imdmanuc2/seymour-miningcore

---

# License

MIT License