# open-webui on Fly.io

Guide for setting up open-webui instance on Fly.io.

Based on [fly-apps/ollama-open-webui](https://github.com/fly-apps/ollama-open-webui)

## Setup

You'll need a [Fly.io](https://fly.io/) account, and the [Flyctl CLI](https://fly.io/docs/flyctl/installing/).

### Launch

```bash
fly launch
```

### Operating your instance

Useful resources for operating and debugging a running instance include `fly logs`, `fly scale show`, `fly ssh console`, the Metrics section of `fly dashboard`.

### Upgrading open-webui

To upgrade to a new version of open-webui, re-deploy the app.

```bash
fly deploy
```

## You're done

That's it! When you visit `https://[app].fly.dev` you should see the Open WebUI interface where you can log in and create the initial admin user.
