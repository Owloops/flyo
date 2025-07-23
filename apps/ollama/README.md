# Ollama

Local LLM server for running language models privately.

## Quick Deploy

```bash
make deploy app=ollama environment=prod region=fra
```

## Required Setup

### Private Network Configuration

```bash
# Create flycast address
fly ips allocate-v6 --private --app ollama-{environment}

# Remove public IPs (keep only flycast)
fly ips list --app ollama-{environment}
fly ips release {public-ip} --app ollama-{environment}
```

## Initial Configuration

### Model Management

Access via temporary machine:

```bash
fly m run -e OLLAMA_HOST=http://ollama-{environment}.flycast --shell ollama/ollama
```

### Pull Models

```bash
ollama pull llama3
ollama pull phi3
ollama pull codellama
```

## Architecture

- **Main app**: Ollama LLM server on private network
- **Access**: Via flycast address only (no public access)

## Useful Commands

| Command | Purpose |
|---------|---------|
| `fly logs --app ollama-prod` | View app logs |
| `fly status --app ollama-prod` | Check app status |
| `fly scale show --app ollama-prod` | Check GPU allocation |
| `fly dashboard --app ollama-prod` | Open web dashboard |
| `fly ips list --app ollama-prod` | View network config |
