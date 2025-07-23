# Linkding

Personal bookmark manager with web UI and browser extensions.

## Quick Deploy

```bash
make deploy app=linkding environment=prod region=fra
```

## Initial Configuration

After deployment, create an admin user:

```bash
fly ssh console --app linkding-{environment}
source /opt/venv/bin/activate
cd /etc/linkding
python manage.py createsuperuser --username=admin --email=admin@example.com
```

### Import Bookmarks

**From Firefox**: Firefox → Bookmarks → Export Bookmarks to HTML → Upload in linkding Settings

**From Other Browsers**: Export as HTML/Netscape format → Import via linkding web interface

### Backup Options

1. **Web Export**: Login → Settings → Export → Download regularly
2. **Database Backup**: SSH console → `python manage.py dumpdata > backup.json`
3. **Automated**: [Litestream integration](https://github.com/fspoettel/linkding-on-fly)

## Useful Commands

| Command | Purpose |
|---------|---------|
| `fly logs --app linkding-prod` | View app logs |
| `fly status --app linkding-prod` | Check app status |
| `fly ssh console --app linkding-prod` | Access terminal |
| `fly dashboard --app linkding-prod` | Open web dashboard |
| `fly scale show --app linkding-prod` | Check scaling |
