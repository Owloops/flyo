# Memos on Fly.io

Guide for setting up Memos instance on Fly.io.

## Setup

You'll need a [Fly.io](https://fly.io/) account, and the [Flyctl CLI](https://fly.io/docs/flyctl/installing/).

### Apps

Clone this repo. Find and replace the application name `memos-pg` with anything you like.

_memos_:

```bash
fly apps create memos-pg
```

## Deploy

```bash
fly deploy
```

### Operating your instance

Useful resources for operating and debugging a running instance include `fly logs`, `fly scale show`, `fly ssh console`, the Metrics section of `fly dashboard`.

### Upgrading Memos

To upgrade to a new version of Memos, re-deploy the app.

```bash
fly deploy
```

## You're done

Enjoy your Memos server :)

If the fly URL keeps loading, try destroying apps and re-creating them.
