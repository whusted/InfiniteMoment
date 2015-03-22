var User = require('../models/user').User,
    Bcrypt = require('bcrypt'),
    Uuid = require('uuid'),
    tokens = require('./tokens');

var accountFuncs = {
    signup: function(request, reply) {
      var user = request.payload;
      if (user.password !== user.confirmPassword) {
        reply("Passwords must match").code(400);
      }

      User.findOne({username: user.username}, function(err, found) {
        if (found) {
          reply("Username " + user.username + " already exists").code(409);
        } else {
          Bcrypt.genSalt(10, function(err, salt) {
            Bcrypt.hash(user.password, salt, function(err, hash) {
              var newUser = new User({
                name: user.name,
                username: user.username,
                password: hash
              });
              newUser.save();
              reply({
                id: user._id,
                name: user.name,
                username: user.username,
                response: "Created a new user"
              });
            });
          });
        }
      });
    },

    login: function (request, reply) {
      var user = request.payload;
      User.findOne({username: user.username}, function(err, existingUser) {
        if (!existingUser) {
          reply("Invalid username.").code(401);
        } else {
          Bcrypt.compare(user.password, existingUser.password, function(err, isValid) {
            if (isValid) {
                if (!existingUser.authToken) {
                  var token = Uuid.v1();
                  // TODO: hash token before saving to db
                  existingUser.authToken = token;
                  existingUser.tokenExpiration = tokens.setExpiration();
                  existingUser.save(function(err) {
                    if (err) {
                      reply(err);
                    } else {
                      reply("Account authorized; note token: " + token);
                    }
                  });
                } else {
                  reply("User is already logged in").code(403);
                }
            } else {
              reply("Invalid password.").code(401);
            }
          });
        }
      });
    },

    logout: function (request, reply) {
      var token = request.headers.authorization;
      User.findOne({authToken: token}, function(err, existingUser) {
        if (!existingUser) {
          reply("User already logged out.").code(401);
        } else {
          setTokenToNull(existingUser);
          existingUser.save(function (err) {
            if (err) {
              reply(err)
            } else {
              reply("User's session has ended.");
            }
          });
        }
      });
    }
};

module.exports = accountFuncs;