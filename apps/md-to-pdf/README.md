# md-to-pdf

A web service for converting markdown to PDF with both web UI and API access.

## Quick Deploy

```bash
make deploy app=md-to-pdf environment=prod region=fra
```

## Required Setup

No additional setup required - the app runs standalone with no external dependencies.

## Initial Configuration

Once deployed, the service will be immediately available at your app URL.

```bash
# Test the service
curl --data-urlencode 'markdown=# Test' --output test.pdf https://md-to-pdf-{environment}.fly.dev
```

## Architecture

- **Main app**: md-to-pdf web interface and API
- **Engine**: Pandoc with multiple PDF conversion backends (weasyprint, wkhtmltopdf, pdflatex)
- **Storage**: Stateless - no persistent storage required

## Useful Commands

| Command | Purpose |
|---------|---------|
| `fly logs --app md-to-pdf-{environment}` | View app logs |
| `fly status --app md-to-pdf-{environment}` | Check app status |
| `fly ssh console --app md-to-pdf-{environment}` | Access terminal |
| `fly dashboard --app md-to-pdf-{environment}` | Open web dashboard |
| `fly scale show --app md-to-pdf-{environment}` | Check scaling |
