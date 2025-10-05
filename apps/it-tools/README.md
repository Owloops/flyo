# IT Tools

Collection of handy online tools for developers with great UX. Includes utilities for encoding/decoding, formatters, generators, and various development tools.

## Quick Deploy

```bash
make deploy app=it-tools environment=prod region=fra
```

## Architecture

- **Main app**: IT Tools web interface running on port 80
- Lightweight Vue.js application
- No database or dependencies required

## Useful Commands

| Command | Purpose |
|---------|---------|
| `fly logs --app it-tools-{environment}` | View app logs |
| `fly status --app it-tools-{environment}` | Check app status |
| `fly ssh console --app it-tools-{environment}` | Access terminal |
| `fly dashboard --app it-tools-{environment}` | Open web dashboard |
| `fly scale show --app it-tools-{environment}` | Check scaling |
