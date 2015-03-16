var Hapi = require('hapi'),
    Joi = require('joi'),
    User = require('./models/user').User,
    Moment = require('./models/moment').Moment,
    Bcrypt = require('bcrypt'),
    Uuid = require('uuid');

var routes = [
  {
    method: 'POST',
    path: '/signup',
    config: {
      validate: {
        payload: Joi.object({
            name: Joi.string().min(3).max(50).required(),
            username: Joi.string().min(3).max(20).required(),
            password: Joi.string().alphanum().min(8).max(50).required(),
            confirmPassword: Joi.string().alphanum().min(8).max(50).required()
        }).unknown(false)
      }
    },
    handler: function(request, reply) {
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
    } 
  },

  {
    method: 'POST',
    path: '/sessions',
    config: {
      validate: {
        payload: Joi.object({
            username: Joi.string().min(3).max(20).required(),
            password: Joi.string().alphanum().required()
        }).unknown(false)
      }
    },
    handler: function (request, reply) {
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
    }
  },

  {
    method: 'DELETE',
    path: '/sessions',
    config: {
      validate: {
        payload: Joi.object({
            Authorization: Joi.string().required() // What else do I know about format of token?
        }).unknown(false)
      }
    },
    handler: function (request, reply) {
      var userToken = request.payload.Authorization;
      User.findOne({authToken: userToken}, function(err, existingUser) {
        if (!existingUser) {
          reply("Invalid username.").code(401);
        } else {
          existingUser.authToken = null;
          existingUser.save(function(err) {
            if (err) {
              reply(err);
            } else {
              reply("User's session has ended.");
            }
          });
        }
      });
    }
  },

  {
    method: 'GET',
    path: '/user/:id',
    handler: function (request, reply) {
      reply('User', reply.params.id);
    }

  },
  // post to new conversation
  {
    method: 'POST',
    path: '/moments',
    config: {
      validate: {
        payload: Joi.object({
            Authorization: Joi.string().required(),
            content: Joi.string().min(1).max(300).required(),
            recipients: Joi.array().items(Joi.string().min(1).required()),
            deliveryDate: Joi.date().iso().required()
        }).unknown(false)
      }
    },
    handler: function (request, reply) {
      var moment = request.payload;
      User.findOne({ authToken: moment.Authorization }, function(err, existingUser) {
        if (!existingUser) {
          reply("Auth token has expired.").code(401);
        } else {
          var username = existingUser.username;
          var newMoment = new Moment({
            content: moment.content,
            author: username,
            recipients: moment.recipients,
            deliveryDate: moment.deliveryDate
          });
          newMoment.save();
          reply({
            id: moment._id,
            author: username,
            recipients: moment.recipients,
            response: "Created a new moment"
          });
        }
      });
    }

  },
  {
    method: 'GET',
    path: '/moments',
    handler: function (request, reply) {
      User.findOne({ authToken: request.headers.authorization }, function(err, existingUser) {
        if (!existingUser) {
          reply("Auth token has expired.").code(401);
        } else {
          var username = existingUser.username;
          Moment.find({ author: username }, function(err, moments) {
            reply(moments);
          });
        }
      });
    }
  },

  {
    method: 'GET',
    path: '/momentsFeed/{userToken}',
    handler: function (request, reply) {
      User.findOne({ authToken: request.params.userToken }, function(err, existingUser) {
        if (!existingUser) {
          reply("Auth token has expired.").code(401);
        } else {
          var username = existingUser.username;
          Moment.find({ recipients: username }, function(err, moments) {
            reply(moments);
          });
        }
      });
    }
  }
  // TODO: search users
  // TODO: add user to friend list
  // TODO: get user's friend list
];
module.exports = routes;