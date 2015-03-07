var Mongoose   = require('mongoose'),
    Config = require('./config');

db.on('error', console.error.bind(console, 'connection error'));  
db.once('open', function callback() {  
    console.log("Connection with database succeeded.");
});

Mongoose.connect('mongodb://' + Config.mongo.username + ':' + Config.mongo.password + '@' + Config.mongo.url + '/' + Config.mongo.database);  
var db = Mongoose.connection;

exports.Mongoose = Mongoose;  
exports.db = db;  