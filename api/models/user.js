var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var userSchema = new Schema({
  id: String,
  handle: {type: String, required: true },
  name: {type: String, required: true },
  blocked: {type: [String], required: false },
  email: {type: String, required: false },
  password: {type: String, required: true },
  creationDate: { type: Date, required: true, default: Date.now }
});

var User = mongoose.model('User', userSchema, 'Users');

exports.User = User;  