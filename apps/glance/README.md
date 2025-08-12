# Glance

Personal dashboard with customizable widgets and feeds for monitoring services, weather, and more.

## Quick Deploy

```bash
make deploy app=glance environment=prod region=fra
```

## Reddit OAuth2 Configuration

To avoid Reddit 403 errors when self-hosting, configure Reddit OAuth2 authentication:

### 1. Create Reddit App

1. Go to [Reddit App Preferences](https://www.reddit.com/prefs/apps)
2. Click "Create App" or "Create Another App"
3. Choose "web app" type
4. Set redirect URI to your domain (e.g., `https://glance.yourdomain.com`)
5. Note down the client ID (under app name) and client secret

### 2. Set Environment Variables

**For GitHub Actions deployment:**
Add these secrets to your repository (Settings → Secrets and variables → Actions):

```bash
REDDIT_APP_NAME=your-app-name
REDDIT_APP_CLIENT_ID=your-client-id
REDDIT_APP_SECRET=your-client-secret
```

**For local deployment:**
Export these environment variables in your shell:

```bash
export REDDIT_APP_NAME="your-app-name"
export REDDIT_APP_CLIENT_ID="your-client-id" 
export REDDIT_APP_SECRET="your-client-secret"
```

### 3. Configuration

The Reddit widgets in `glance.yml.template` use these environment variables automatically:

```yaml
- type: reddit
  subreddit: selfhosted
  app-name: ${REDDIT_APP_NAME}
  client-id: ${REDDIT_APP_CLIENT_ID}
  client-secret: ${REDDIT_APP_SECRET}
```

This configuration uses `oauth.reddit.com` endpoints instead of `www.reddit.com`, providing reliable access even from VPS deployments.

## Useful Commands

| Command | Purpose |
|---------|---------|
| `fly logs --app glance-prod` | View app logs |
| `fly status --app glance-prod` | Check app status |
| `fly ssh console --app glance-prod` | Access terminal |
| `fly dashboard --app glance-prod` | Open web dashboard |
| `fly scale show --app glance-prod` | Check scaling |
