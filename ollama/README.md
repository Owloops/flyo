# Ollama on Fly.io

Guide for setting up Ollama on Fly.io.

## Setup

You'll need a [Fly.io](https://fly.io/) account, and the [Flyctl CLI](https://fly.io/docs/flyctl/installing/).

### Apps

Clone this repo. Find and replace the application name `ollama-pg` with anything you like.

_ollama_:

```bash
fly apps create ollama-pg
```

## Private Network

We don’t want to expose the GPU to the internet, so we’re going to create a flycast address to expose it to other services on your private network. To create a flycast address, run this command:

```bash
fly ips allocate-v6 --private
```

Next, you may need to remove all of the other public IP addresses for the app to lock it away from the public. Get a list of them with `fly ips list` and then remove them with `fly ips release <ip>`. Delete everything but your flycast IP.

## Deploy

```bash
fly deploy
```

### Operating your instance

Useful resources for operating and debugging a running instance include `fly logs`, `fly scale show`, `fly ssh console`, the Metrics section of `fly dashboard`.

```bash
fly m run -e OLLAMA_HOST=http://ollama-pg.flycast --shell ollama/ollama
```

```bash
ollama pull llama3
ollama pull phi3
```

### Upgrading Ollama

To upgrade to a new version of Ollama, re-deploy the app.

```bash
fly deploy
```

## You're done

Enjoy your Ollama server :)

If the fly URL keeps loading, try destroying apps and re-creating them.
