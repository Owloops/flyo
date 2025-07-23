# {AppName}

{Brief description of what this app does}

## Quick Deploy

```bash
make deploy app={appname} environment=prod region=fra
```

## Required Setup

{Optional: Add any secrets, volumes, or pre-deployment setup needed}

```bash
# Example: Create secret
fly secrets set MY_SECRET=value --app {appname}-{environment}

# Example: Create volume
fly volumes create my_data --region {region} --app {appname}-{environment}
```

## Initial Configuration

{Optional: Add any post-deployment setup steps}

```bash
# Example: Create admin user
fly ssh console --app {appname}-{environment}
{commands to run}
```

## Architecture

{Optional: Explain multi-service apps or special architecture}

- **Main app**: {AppName} web interface
- **Database**: User data storage
- **Cache**: Performance optimization

## Useful Commands

| Command | Purpose |
|---------|---------|
| `fly logs --app {appname}-{environment}` | View app logs |
| `fly status --app {appname}-{environment}` | Check app status |
| `fly ssh console --app {appname}-{environment}` | Access terminal |
| `fly dashboard --app {appname}-{environment}` | Open web dashboard |
| `fly scale show --app {appname}-{environment}` | Check scaling |
