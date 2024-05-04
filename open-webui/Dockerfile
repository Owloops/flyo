FROM ollama/ollama:latest AS ollama

FROM ghcr.io/open-webui/open-webui:latest

COPY --from=ollama / /

WORKDIR /app/backend

COPY start.sh ./
RUN chmod +x start.sh

CMD ["./start.sh"]
