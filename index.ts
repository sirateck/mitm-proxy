#!/bin/env ts-node
const port = 3131;
import net from "net";
import Proxy from "http-mitm-proxy";
const proxy = Proxy();

proxy.onConnect(function(req, socket, head) {
  const host = req?.url?.split(":")[0];
  const port = req?.url?.split(":")[1] ?? '443';

  console.log('Tunnel to', req.url);
  const conn = net.connect({
    port: parseInt(port,10),
    host: host,
    allowHalfOpen: true
  }, function(){
    conn.on('finish', () => {
      socket.destroy();
    });
    socket.on('close', () => {
      conn.end();
    });
    socket.write('HTTP/1.1 200 OK\r\n\r\n', 'utf-8', function(){
      conn.pipe(socket);
      socket.pipe(conn);
    })
  });

  conn.on('error', function(err) {
    filterSocketConnReset(err as Error & {errno:string}, 'PROXY_TO_SERVER_SOCKET');
  });
  socket.on('error', function(err) {
    filterSocketConnReset(err as Error & {errno:string}, 'CLIENT_TO_PROXY_SOCKET');
  });
});

// Since node 0.9.9, ECONNRESET on sockets are no longer hidden
function filterSocketConnReset(err: Error & {errno:string}, socketDescription:string) {
  if (err.errno === 'ECONNRESET') {
    console.log('Got ECONNRESET on ' + socketDescription + ', ignoring.');
  } else {
    console.log('Got unexpected error on ' + socketDescription, err);
  }
}

proxy.listen({ port, host:'::' }, function() {
    console.log('Proxy server listening on ' + port);
});
