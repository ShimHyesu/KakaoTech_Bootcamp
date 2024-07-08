#
# Unix Domain Sockets 서버
#

# 라이브러리 임포트 및 소켓 파일 경로 설정
import socket
import os

SOCKET_FILE = "/tmp/mysocket"

# 기존 소켓 파일 삭제
if os.path.exists(SOCKET_FILE):
  os.remove(SOCKET_FILE)

# 소켓 생성 및 바인딩
server = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
server.bind(SOCKET_FILE)

# 소켓 대기 및 클라이언트 연결 수락
server.listen(1)
print("서버가 클라이언트를 기다리고 있습니다...")

conn, addr = server.accept()
print("클라이언트 연결 수락")

# 데이터 송수신
while True:
  data = conn.recv(512)
  if not data:
    break
  print("클라이언트로부터 받은 데이터:", data.decode())
  conn.sendall(data)

# 연결 종료
conn.close()