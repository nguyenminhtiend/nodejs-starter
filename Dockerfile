FROM node:14.15-alpine

RUN mkdir -p /usr/app

WORKDIR /usr/app

COPY package*.json ./

RUN npm install --only=production 

COPY src ./src

EXPOSE 3000

CMD ["node", "src/server.js"]