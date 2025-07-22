# LibreChat on Fly.io

Guide for setting up LibreChat instance on Fly.io.

## Setup

You'll need a [Fly.io](https://fly.io/) account, and the [Flyctl CLI](https://fly.io/docs/flyctl/installing/).

### Apps

Clone this repo. Find and replace the application name `librechat-pg` with anything you like.

_librechat_:

```bash
fly apps create librechat-pg
```

_mongodb_:

```bash
fly apps create librechat-pg-mongod
```

## Deploy

```bash
bin/fly-mongod deploy
fly deploy
```

### Operating your instance

Useful resources for operating and debugging a running instance include `fly logs`, `fly scale show`, `fly ssh console`, the Metrics section of `fly dashboard`.

### Upgrading LibreChat

To upgrade to a new version of LibreChat, re-deploy the app.

```bash
fly deploy
```

You should also regularly update MongoDB.

```bash
bin/fly-mongod deploy
```

## You're done

Enjoy your LibreChat server :)

If the fly URL keeps loading, try destroying apps and re-creating them.
