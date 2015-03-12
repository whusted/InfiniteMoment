var Hapi = require('hapi'),
    routes = require('./routes'),
    Mongoose = require('mongoose'),
    Config = require('./config');

var mongo_url = 'mongodb://' + Config.mongo.url + '/' + Config.mongo.database;
Mongoose.connect(mongo_url);

var server = new Hapi.Server();
server.connection({ port: 7777 });

server.route(routes);
server.start(function () {
  console.log("Server started on localhost:7777");
});