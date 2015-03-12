var Hapi = require('hapi'),
    routes = require('./routes'),
    Mongoose = require('mongoose'),
    Config = require('./config'),
    Bcrypt = require('bcrypt'),
    Basic = require('hapi-auth-basic');

var mongo_url = 'mongodb://' + Config.mongo.url + '/' + Config.mongo.database;
Mongoose.connect(mongo_url);

var server = new Hapi.Server();
server.connection({ port: 7777 });

var validate = function (username, password, callback) {
  Bcrypt.compare(password, user.password, function (err, isValid) {
    callback(err, isValid, { id: user.id, name: user.name });
  });
};

server.register(Basic, function (err) {
  server.auth.strategy('simple', 'basic', { validateFunc: validate });
  server.route(routes);
});


server.start(function () {
  console.log("Server started on localhost:7777");
});
module.exports = server;