FROM node:22

WORKDIR /app

COPY src/package*.json /app/

RUN npm install

COPY ./src /app

EXPOSE 3000

USER nobody

CMD ["node", "server.mjs"]
