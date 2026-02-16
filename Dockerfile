FROM node:22-slim AS builder
WORKDIR /slackbot
COPY package.json ./
COPY tsconfig.json ./
COPY package-lock.json ./
COPY src/ ./src/
RUN npm install && npm run build

FROM node:22-slim
WORKDIR /slackbot
COPY package.json ./
COPY --from=builder /slackbot/dist/ ./dist/
COPY --from=builder /slackbot/node_modules/ node_modules/
COPY config/ ./config/
CMD ["node", "dist/src/app.js"]
