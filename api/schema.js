var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var User = new Schema({
  id: String,
  username: String,
  email: String,
  name: String,
  password: String,
  blocked: [String]
});