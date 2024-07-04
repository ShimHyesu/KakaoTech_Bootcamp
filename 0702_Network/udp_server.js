//UDP 서버 코드 작성
const dgram = require('dgram');
const server = dgram.createSocket('udp4');

server.on('message', (msg, rinfo) => {
    console.log(`Server got: ${msg} from ${rinfo.address}:${rinfo.port}`);
    server.send(`Echo: ${msg}`, rinfo.port, rinfo.address);
});

server.bind(41234, () => {
    console.log('UDP server listening on port 41234');
});
