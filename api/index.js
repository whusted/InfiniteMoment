var Hapi = require('hapi'),
    routes = require('./routes'),
    mongoose   = require('mongoose'),
    Config = require('./config');

var server = new Hapi.Server();
server.connection({ port: 7777 });

mongoose.connect('mongodb://' + Config.mongo.username + ':' + Config.mongo.password + '@' + Config.mongo.url + '/' + Config.mongo.database);  
var db = mongoose.connection;

server.route(routes);
server.start();
console.log("Server started on localhost:7777");