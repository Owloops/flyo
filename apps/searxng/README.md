# SearXNG

Meta search engine that aggregates results from multiple search engines.

## Quick Deploy

```bash
make deploy app=searxng environment=prod region=fra
```

## Required Setup

### Secret Key

```bash
export SEARXNG_SECRET=$(openssl rand -hex 32)
fly secrets set SEARXNG_SECRET=$SEARXNG_SECRET --app searxng-{environment}
```

### Storage Volumes

```bash
# Main app data
fly volumes create searxng_data --region {region} --app searxng-{environment}

# Redis data (recommended)  
fly volumes create searxng_redis_data --region {region} --app searxng-{environment}-redis
```

## Architecture

- **Main app**: SearXNG search interface
- **Redis**: Caching and rate limiting
- **Volume**: Persistent configuration storage

## Useful Commands

| Command | Purpose |
|---------|---------|
| `fly logs --app searxng-prod` | View main app logs |
| `fly status --app searxng-prod` | Check app status |
| `fly logs --app searxng-prod-redis` | View Redis logs |
| `fly ssh console --app searxng-prod` | Access main app |
| `fly dashboard --app searxng-prod` | Open web dashboard |
