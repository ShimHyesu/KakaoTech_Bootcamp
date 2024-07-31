FROM node:20
WORKDIR /app 
# package*.json 파일 먼저 읽고 npm install -> 최적화
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 4000
CMD ["node", "app.js"]