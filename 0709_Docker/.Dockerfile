# 베이스 이미지를 지정합니다 (Node.js 이미지).
FROM node:14

# 작업 디렉토리를 설정합니다.
WORKDIR /usr/src/app

# package.json 및 package-lock.json 파일을 컨테이너에 복사합니다.
COPY package*.json ./

# 프로젝트의 종속성을 설치합니다.
RUN npm install

# 애플리케이션 소스 코드를 복사합니다.
COPY . .

# 애플리케이션이 수신할 포트를 지정합니다.
EXPOSE 3000

# 컨테이너가 시작될 때 실행할 명령어를 지정합니다.
CMD ["node", "app.js"]
