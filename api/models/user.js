
var mongoose = require('mongoose');
var Schema = mongoose.Schema,
    passportLocalMongoose = require('passport-local-mongoose');

var userSchema = new Schema({
  id: String,
  username: {type: String, required: true },
  name: {type: String, required: true },
  blocked: {type: [String], required: false },
  email: {type: String, required: true },
  password: {type: String, required: true },
  creationDate: { type: Date, required: true, default: Date.now }
});

userSchema.plugin(passportLocalMongoose, { usernameField: 'email', hashField: 'password', usernameLowerCase: true });

var User = mongoose.model('User', userSchema, 'Users');

exports.User = User;  