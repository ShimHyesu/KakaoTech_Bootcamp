//UDP 클라아언트 코드 작성
const dgram = require('dgram');
const client = dgram.createSocket('udp4');
const message = Buffer.from('Hello, server! Love, Client.');

client.send(message, 41234, 'localhost', (err) => {
    if (err) console.log(err);
    else console.log('Message sent');

    client.on('message', (msg, rinfo) => {
        console.log(`Client got: ${msg} from ${rinfo.address}:${rinfo.port}`);
        client.close();
    });
});
