# Glance on Fly.io

Follow this guide to set up and deploy your own [Glance](https://github.com/glanceapp/glance) instance on Fly.io in just a few steps.

## Setup

You'll need a [Fly.io](https://fly.io/) account, and the [Flyctl CLI](https://fly.io/docs/flyctl/installing/).

### Apps

Clone this repository. Replace the application name `glance-pg` with any unique name of your choice.

_glance_:

```bash
fly apps create glance-pg
```

## Deploy

```bash
fly deploy
```

### Operating your instance

Useful resources for operating and debugging a running instance include `fly logs`, `fly scale show`, `fly ssh console`, the Metrics section of `fly dashboard`.

### Upgrading Glance

To upgrade to a new version of Glance, re-deploy the app.

```bash
fly deploy
```

## You're done

Enjoy your glance server :)

If the fly URL keeps loading, try destroying apps and re-creating them.
