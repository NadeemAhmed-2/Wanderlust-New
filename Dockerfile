FROM node:20-alpine
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install --omit=dev
COPY . .
ENV MONGO_URL=""
EXPOSE 8082
CMD ["node", "app.js"]
