FROM cache.ecsc2024.it/library/node:18

WORKDIR /app
COPY package.json package-lock.json ./

RUN npm install

COPY app.js index.html ./

CMD ["node", "app.js"]
