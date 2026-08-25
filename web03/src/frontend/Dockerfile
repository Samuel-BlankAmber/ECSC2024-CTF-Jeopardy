FROM node:21-alpine AS build
WORKDIR /app

COPY . .
COPY package.json pnpm-lock.yaml ./
# Pinned: latest pnpm now requires Node 22, and the lockfile is version 9.
RUN npm install -g pnpm@9
RUN pnpm install --frozen-lockfile
RUN pnpm run build

FROM node:21-alpine
WORKDIR /app

COPY --from=build /app/build/ /app/package.json /app/pnpm-lock.yaml ./
RUN npm install -g pnpm@9
RUN pnpm install --frozen-lockfile --prod

ENTRYPOINT ["/usr/local/bin/node", "index.js"]
CMD []
