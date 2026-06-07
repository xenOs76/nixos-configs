# NixOS config TODOs

## Storage

- [ ] Migrate zero from MinIO to Garage
  - MinIO is marked insecure in nixpkgs 26.05; currently permitted via `nixpkgsConfig.permittedInsecurePackages`
  - Related: Tempo S3 backend, nginx minio proxies, btrbk minio snapshots
  - See branch `feat/add_garage` for prior work

## Observability

- [ ] Replace removed Promtail log shipping on zero
  - `services.promtail` was removed in 26.05 (EOL)
  - Candidates: `services.alloy` (Grafana Alloy) or `services.fluent-bit` → Loki
  - Previous config pushed systemd journal logs to local Loki
