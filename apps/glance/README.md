# Glance

Personal dashboard with customizable widgets and feeds for monitoring services, weather, and more.

## Quick Deploy

```bash
make deploy app=glance environment=prod region=fra
```

## Useful Commands

| Command | Purpose |
|---------|---------|
| `fly logs --app glance-prod` | View app logs |
| `fly status --app glance-prod` | Check app status |
| `fly ssh console --app glance-prod` | Access terminal |
| `fly dashboard --app glance-prod` | Open web dashboard |
| `fly scale show --app glance-prod` | Check scaling |
