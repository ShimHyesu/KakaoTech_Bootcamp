//tcp 클라이언트 코드 작성
const net = require('net');

const client = net.createConnection({ port: 8080 }, () => {
    console.log('Connected to server');
    client.write('Hello, server! Love, Client.');
});

client.on('data', (data) => {
    console.log(`Received: ${data}`);
    client.end();
});

client.on('end', () => {
    console.log('Disconnected from server');
});
