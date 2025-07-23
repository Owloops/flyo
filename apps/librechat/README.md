# LibreChat

AI chat interface with support for multiple language models.

## Quick Deploy

```bash
make deploy app=librechat environment=prod region=fra
```

## Initial Configuration

```bash
# Access the app to create your first admin account
# Navigate to https://librechat-prod.fly.dev
# Register your first user account (first user becomes admin)
```

**Ollama Integration**: To use with Ollama, update the `baseURL` in `librechat.example.yaml` to match your Ollama deployment name and environment (e.g., `http://ollama-prod.flycast/v1/`).

## Architecture

- **Main app**: LibreChat web interface
- **MongoDB**: User data and chat history

The Makefile automatically creates and deploys both services.

## Useful Commands

| Command | Purpose |
|---------|---------|
| `fly logs --app librechat-prod` | View main app logs |
| `fly status --app librechat-prod` | Check app status |
| `fly logs --app librechat-prod-mongo` | View MongoDB logs |
| `fly ssh console --app librechat-prod` | Access main app |
| `fly dashboard --app librechat-prod` | Open web dashboard |
