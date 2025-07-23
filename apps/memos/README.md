# Memos

Privacy-focused note-taking service with markdown support for personal knowledge management.

## Quick Deploy

```bash
make deploy app=memos environment=prod region=fra
```

## Initial Configuration

```bash
# Access the app to create your first admin account
# Navigate to https://memos-prod.fly.dev
# Register your first user account (first user becomes admin)
```

## Useful Commands

| Command | Purpose |
|---------|---------|
| `fly logs --app memos-prod` | View app logs |
| `fly status --app memos-prod` | Check app status |
| `fly ssh console --app memos-prod` | Access terminal |
| `fly dashboard --app memos-prod` | Open web dashboard |
| `fly scale show --app memos-prod` | Check scaling |
