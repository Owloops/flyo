# Redlib

Privacy-focused Reddit frontend with no tracking, ads, or JavaScript requirements.

## Quick Deploy

```bash
make deploy app=redlib environment=prod region=fra
```

## Useful Commands

| Command | Purpose |
|---------|---------|
| `fly logs --app redlib-prod` | View app logs |
| `fly status --app redlib-prod` | Check app status |
| `fly ssh console --app redlib-prod` | Access terminal |
| `fly dashboard --app redlib-prod` | Open web dashboard |
| `fly scale show --app redlib-prod` | Check scaling |
