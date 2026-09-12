FROM node:24-alpine
RUN corepack enable && corepack prepare pnpm@10.16.0 --activate
WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile --prod
COPY index.js ./
EXPOSE 3000
CMD ["node", "index.js"]
