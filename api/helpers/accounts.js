var User = require('../models/user').User,
    Bcrypt = require('bcrypt'),
    Uuid = require('uuid'),
    tokens = require('./tokens');

var accountFuncs = {
    signup: function(request, reply) {
      var user = request.payload;
      if (user.password !== user.confirmPassword) {
        reply({
          error: "Passwords don't match",
          message: "Passwords must match"
        }).code(400);
      } else {
        User.findOne({username: user.username}, function (err, found) {
          if (found) {
            reply({
              error: "Username taken",
              message: "Username " + user.username + " is already taken"
            }).code(409);
          } else {
            Bcrypt.genSalt(10, function(err, salt) {
              Bcrypt.hash(user.password, salt, function (err, hash) {
                var newUser = new User({
                  username: user.username,
                  password: hash,
                  phone: user.phone
                });
                newUser.save();
                reply({
                  id: user._id,
                  username: user.username,
                  response: "Created a new user"
                });
              });
            });
          }
        });
      }
      
    },

    login: function (request, reply) {
      var user = request.payload;
      User.findOne({username: user.username}, function (err, existingUser) {
        if (!existingUser) {
          reply({
            error: "Invalid username.",
            message: "Please enter a valid username."
          }).code(401);
        } else {
          Bcrypt.compare(user.password, existingUser.password, function (err, isValid) {
            if (isValid) {
                if (!existingUser.authToken) {
                  var token = Uuid.v1();
                  // TODO: hash first
                  existingUser.authToken = token;
                  existingUser.tokenExpiration = tokens.setExpiration();
                  existingUser.save(function(err) {
                    if (err) {
                      reply({
                        error: "error", // yikes, man
                        message: err
                      });
                    } else {
                      reply({
                        message: "Success",
                        response: "Account authorized; note token",
                        token: token
                      });
                    }
                  });
                } else {
                  reply({
                    error: "Invalid login",
                    message: "User is already logged in."
                  }).code(403);
                }
            } else {
              reply({
                error: "Invalid password.",
                message: "Password was incorrect. Please try again."
              }).code(401);
            }
          });
        }
      });
    },

    logout: function (request, reply) {
      var token = request.payload.Authorization;
      User.findOne({authToken: token}, function (err, existingUser) {
        if (!existingUser) {
          reply({
            error: "Already logged out",
            message: "User already logged out."
          }).code(401);
        } else {
          tokens.setTokenToNull(existingUser);
          existingUser.save(function (err) {
            if (err) {
              reply({
                error: "error", // yikes, man
                message: err
              });
            } else {
              reply({
                message: "Success",
                response: "User's session has ended."
              });
            }
          });
        }
      });
    }
};

module.exports = accountFuncs;