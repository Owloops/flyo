# FlyApps

Ready-to-deploy self-hosted applications for Fly.io.

## Prerequisites

- [Fly CLI](https://fly.io/docs/flyctl/install/) installed and authenticated
- `make` and `jq`

Run `make doctor` to verify everything is set up.

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
make deploy app=librechat environment=prod region=fra

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
4. Set region (default: otp)

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

## Directory Structure

```text
flyapps/
├── Makefile
├── apps/
│   ├── glance/fly.toml
│   ├── librechat/
│   │   ├── fly.toml
│   │   └── fly.mongod.toml
│   └── searxng/
│       ├── fly.toml
│       └── fly.redis.toml
└── .github/workflows/deploy.yml
```

## License

Open source. Individual apps may have their own licenses.
