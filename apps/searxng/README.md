# SearXNG on Fly.io

Guide for setting up SearXNG instance on Fly.io.

## Setup

You'll need a [Fly.io](https://fly.io/) account, and the [Flyctl CLI](https://fly.io/docs/flyctl/installing/).

### Apps

Clone this repo. Find and replace the application name `searxng-pg` with anything you like.

_searxng_:

```bash
fly apps create searxng-pg
```

_redis_:

```bash
fly apps create searxng-pg-redis
```

### Secrets

```bash
export SEARXNG_SECRET=$(openssl rand -hex 32)
fly secrets set SEARXNG_SECRET=$SEARXNG_SECRET
```

### Storage

The [`fly.toml`](./fly.toml) uses a `[mounts]` section to connect the `/etc/searxng` folder to a persistent volume.

Create that volume below:

```bash
fly volumes create --region cdg searxng_data
```

We recommend adding persistent storage for Redis data. If you skip this step, data will be lost across deploys or restarts. For Fly apps, the volume needs to be in the same region as the app instances. For example:

```bash
bin/fly-redis volumes create --region cdg searxng_redis_data
```

## Deploy

```bash
bin/fly-redis deploy
fly deploy
```

### Operating your instance

Useful resources for operating and debugging a running instance include `fly logs`, `fly scale show`, `fly ssh console`, the Metrics section of `fly dashboard`.

### Upgrading SearXNG

To upgrade to a new version of SearXNG, re-deploy the app.

```bash
fly deploy
```

You should also regularly update Redis instances.

```bash
bin/fly-redis deploy
```

## You're done

Enjoy your SearXNG server.

If the fly URL keeps loading, try destroying apps and re-creating them in order, the searxng at first, redis at last.
