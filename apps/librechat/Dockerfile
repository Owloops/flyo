FROM librechat/librechat-dev:latest

WORKDIR /app

COPY .env.example .env
COPY librechat.example.yaml librechat.yaml

EXPOSE 3080

CMD ["npm", "run", "backend"]
