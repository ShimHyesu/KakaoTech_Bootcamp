#
# Unix Domain Sockets 클라이언트
#

# 라이브러리 임포트 및 소켓 파일 경로 설정
import socket

SOCKET_FILE = "/tmp/mysocket"

# 소켓 생성 및 서버 연결
client = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
client.connect(SOCKET_FILE)

# 메세지 전송
message = "안녕하세요, 서버!"
client.sendall(message.encode())

# 응답 수신
data = client.recv(1024)
print("서버로부터 받은 데이터:", data.decode())

# 연결 종료
client.close()