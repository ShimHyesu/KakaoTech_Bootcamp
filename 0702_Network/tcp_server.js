//tcp 서버 코드 작성
const net = require('net');

const server = net.createServer((socket) => {
    console.log('Client connected');

    socket.on('data', (data) => {
        console.log(`Received: ${data}`);
        socket.write(`Echo: ${data}`);
    });

    socket.on('end', () => {
        console.log('Client disconnected');
    });
});

server.listen(8080, () => {
    console.log('TCP server listening on port 8080');
});
