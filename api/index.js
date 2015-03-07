var Hapi = require('hapi'),
    routes = require('./routes');

var server = new Hapi.Server();
server.connection({ port: 7777 });

server.route(routes);
server.start();
console.log("Server started on localhost:7777");