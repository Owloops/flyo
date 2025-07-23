# Kuma

Uptime monitoring tool with status page and alerting capabilities for tracking service availability.

## Quick Deploy

```bash
make deploy app=kuma environment=prod region=fra
```

## Useful Commands

| Command | Purpose |
|---------|---------|
| `fly logs --app kuma-prod` | View app logs |
| `fly status --app kuma-prod` | Check app status |
| `fly ssh console --app kuma-prod` | Access terminal |
| `fly dashboard --app kuma-prod` | Open web dashboard |
| `fly scale show --app kuma-prod` | Check scaling |
