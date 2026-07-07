# Seymour MiningCore API Contract

Base Path

```
/api/v1
```

## Read Endpoints

- GET /status
- GET /system
- GET /health
- GET /version
- GET /license
- GET /pools
- GET /workers
- GET /blocks
- GET /payments
- GET /hashrate
- GET /nodes
- GET /logs
- GET /config
- GET /alerts
- GET /updates
- GET /security/tamper-status

## Management Endpoints

- POST /service/start
- POST /service/stop
- POST /service/restart
- POST /config/validate
- POST /config/apply
- POST /pools
- PUT /pools/{poolId}
- DELETE /pools/{poolId}
- POST /nexus/register
- POST /updates/check
- POST /updates/apply

## Supported Pool Modes

- solo
- public

## Initial Coins

- BTC
- BCH
