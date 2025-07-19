# Linkding on Fly.io

Guide for setting up Linkding instance on Fly.io.

## Setup

You'll need a [Fly.io](https://fly.io/) account, and the [Flyctl CLI](https://fly.io/docs/flyctl/installing/).

### Apps

Clone this repo. Find and replace the application name `linkding-pg` with anything you like.

_linkding_:

```bash
fly apps create linkding-pg
```

## Deploy

```bash
fly deploy
```

### Initial Setup

After first deployment, create an admin user:

```bash
fly ssh console
source /opt/venv/bin/activate
cd /etc/linkding
python manage.py createsuperuser --username=admin --email=admin@example.com
```

### Import Existing Bookmarks

To import bookmarks from Firefox or other browsers:

1. **Export from Firefox:**
   - Open Firefox → Bookmarks → Manage Bookmarks (Ctrl+Shift+O)
   - Import and Backup → Export Bookmarks to HTML
   - Save the HTML file

2. **Import to Linkding:**
   - Login to your linkding instance
   - Go to Settings → Import
   - Upload the HTML file from Firefox
   - Linkding will import all bookmarks with their folder structure

**Supported formats:** HTML (from any browser), Netscape bookmark format

### Operating your instance

Useful resources for operating and debugging a running instance include `fly logs`, `fly scale show`, `fly ssh console`, the Metrics section of `fly dashboard`.

### Upgrading Linkding

To upgrade to a new version of Linkding, re-deploy the app.

```bash
fly deploy
```

## Backups (Recommended)

Since bookmarks are personal data, consider setting up backups:

### Option 1: Manual Export (Simple)

1. Login to your linkding instance
2. Go to Settings → Export
3. Download HTML or CSV backup regularly

### Option 2: Database Backup via SSH

```bash
fly ssh console
source /opt/venv/bin/activate
cd /etc/linkding
python manage.py dumpdata > backup.json
# Copy backup.json to local machine via scp or other means
```

### Option 3: Automated Backups with Litestream

For automatic continuous backups to cloud storage, see this comprehensive guide:
<https://github.com/fspoettel/linkding-on-fly>

This requires a custom Dockerfile but provides real-time SQLite replication to Backblaze B2.

## You're done

Enjoy your Linkding server :)

If the fly URL keeps loading, try destroying apps and re-creating them.
