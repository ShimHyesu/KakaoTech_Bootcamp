# 베이스 이미지 지정
FROM node:14

# 작업 디렉토리 설정
WORKDIR /app

# 파일이나 디렉토리 컨테이너로 복사
COPY . .

# 컨테이너 안에서 명령어 실행
RUN npm install

# 컨테이너 시작될 때 시작할 명령어
CMD ["npm", "start"]