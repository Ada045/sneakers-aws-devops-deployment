# Build stage

FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY . .

RUN npm run build

# Production stage

FROM node:20-alpine AS production

WORKDIR /app

ENV NODE_ENV=production

COPY package*.json ./

RUN npm ci --omit=dev && npm cache clean --force

COPY config ./config
COPY middleware ./middleware
COPY models ./models
COPY routes ./routes
COPY server.js ./

COPY --from=builder /app/client/build ./client/build

USER node

EXPOSE 5000

CMD ["node", "server.js"]