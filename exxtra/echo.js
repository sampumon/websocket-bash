var net = require('net');

var server = net.createServer(function (socket) {
  socket.write("Echo server\n");
  socket.pipe(socket);
});

server.listen(1337, "127.0.0.1");

console.log('Server running at http://127.0.0.1:1337/');
