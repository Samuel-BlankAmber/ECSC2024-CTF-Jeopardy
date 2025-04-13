FROM node:22

WORKDIR /app

COPY src/package*.json /app/

RUN npm install

COPY ./src /app

EXPOSE 3000

RUN addgroup --system app && adduser --system --ingroup app app
RUN mkdir /data && chown app:app /data

USER app

CMD ["node", "server.mjs"]
