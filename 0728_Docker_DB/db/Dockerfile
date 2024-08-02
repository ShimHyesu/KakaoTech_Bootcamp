FROM mariadb:latest

# /docker-entrypoint-initdb.d/ : 컨테이너가 처음 시작될 때 실행되는 SQL 파일을 저장하는 디렉토리
# 데이터베이스 초기화 작업 진행
COPY initdb.sql /docker-entrypoint-initdb.d

# VOLUME [ "/var/lib/mariadb" ]

# MariaDB Docker 이미지가 이미 ENTRYPOINT와 CMD를 설정해서 따로 지정하지 않아도 됨
# CMD ["mariadbd"] 