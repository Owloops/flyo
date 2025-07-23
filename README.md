# Flyons

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub stars](https://img.shields.io/github/stars/Owloops/flyons.svg)](https://github.com/Owloops/flyons/stargazers)
[![Last commit](https://img.shields.io/github/last-commit/Owloops/flyons.svg)](https://github.com/Owloops/flyons/commits/main)

Ready-to-deploy self-hosted applications for Fly.io.

## Prerequisites

- [Fly CLI](https://fly.io/docs/flyctl/install/) installed and authenticated
- `make` and `jq`

Run `make doctor` to verify everything is set up.

**Optional**: Disable analytics warnings with `fly settings analytics disable`

## Available Apps

| App | Description | Services |
|-----|-------------|----------|
| glance | Personal dashboard | No |
| kuma | Uptime monitoring | No |
| librechat | AI chat interface | MongoDB |
| linkding | Bookmark manager | No |
| memos | Note-taking app | No |
| ollama | Local LLM server | No |
| redlib | Reddit frontend | No |
| searxng | Meta search engine | Redis |

## Quick Start

```bash
# Authenticate
fly auth login

# Deploy an app
make deploy app=glance

# With environment suffix
make deploy app=glance environment=staging

# Custom region
make deploy app=glance environment=prod region=fra

# Check status
make status app=glance environment=staging
```

## Commands

| Command | Description |
|---------|-------------|
| `help` | Show usage |
| `doctor` | Check prerequisites |
| `create` | Create new app |
| `deploy` | Deploy app |
| `status` | Show app status |
| `logs` | Show recent logs |
| `destroy` | Delete app |
| `matrix` | List apps as JSON |

## Multi-Service Apps

Apps like `librechat` and `searxng` automatically deploy additional services (MongoDB, Redis) when needed.

## GitHub Actions

1. Go to Actions > Deploy workflow
2. Select apps to deploy
3. Set environment (optional)
4. Set region (default: fra)

Add `FLY_API_TOKEN` to your repository secrets.

## Examples

```bash
# Development workflow
make create app=memos environment=dev
make deploy app=memos environment=dev
make logs app=memos environment=dev
make destroy app=memos environment=dev

# Production deployment
make deploy app=librechat environment=prod region=fra

# Multiple apps
for app in glance kuma linkding; do
  make deploy app=$app
done
```

## Troubleshooting

### Authentication Error

```bash
fly auth login
```

### App Already Exists

```bash
fly apps list
make deploy app=glance environment=v2
```

### Region Not Available

```bash
fly platform regions
make deploy app=glance region=ams
```

## Adding New Apps

### 1. Create App Structure

```bash
mkdir apps/myapp && cd apps/myapp
fly launch --no-deploy
```

### 2. Deploy

```bash
make deploy app=myapp environment=prod region=fra
```

### 3. Create README (Optional)

Copy and customize the [README template](templates/README.template.md).

## Contributing

- **Add new apps**: See [Adding New Apps](#adding-new-apps) section
- **Report issues**: Submit bug reports and feature requests
- **Submit PRs**: Follow existing code style and update documentation

## License

This project is licensed under the [MIT License](LICENSE).
