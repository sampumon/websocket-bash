// http://laktek.com/2010/05/04/implementing-web-socket-servers-with-node-js/

var util = require("util");
var net = require("net");
var http = require("http");

function createTestServer(){
  return new testServer();
};

function testServer(){
  var server = this;
  http.Server.call(server, function(){});

  server.addListener("connection", function(){
    // requests_recv++;
  });

  server.addListener("request", function(req, res){
    res.writeHead(200, {"Content-Type": "text/plain"});
    res.write("okay");
    res.end();
  });

  server.addListener("upgrade", function(req, socket, upgradeHead){
    console.log("got upgraded");
    socket.write( "HTTP/1.1 101 Web Socket Protocol Handshake\r\n"
                + "Upgrade: WebSocket\r\n"
                + "Connection: Upgrade\r\n"
                + "WebSocket-Origin: http://localhost:3400\r\n"
                + "WebSocket-Location: ws://localhost:3400/\r\n"
                + "\r\n"
                );

    request_upgradeHead = upgradeHead;

    socket.ondata = function(d, start, end){
      //var data = d.toString('utf8', start, end);
      var original_data = d.toString('utf8', start, end);
      var data = original_data.split('\ufffd')[0].slice(1);
      if(data == "kill"){
        socket.end();
      } else {
        util.puts(data);
        socket.write("\u0000", "binary");
        socket.write(data, "utf8");
        socket.write("\uffff", "binary");
      }
    };
  });
};

util.inherits(testServer, http.Server);

var server = createTestServer();
server.listen(1337);
