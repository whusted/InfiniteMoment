var Hapi = require('hapi'),
    Joi = require('joi'),
    User = require('./models/user').User,
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
              handle: Joi.string().min(3).max(20).required(),
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

        User.find({handle: user.handle}, function(err, found) {
          if (found.length) {
            reply("Handle already exists").code(409);
          } else {
            Bcrypt.genSalt(10, function(err, salt) {
              Bcrypt.hash(user.password, salt, function(err, hash) {
                var newUser = new User({
                  name: user.name,
                  handle: user.handle,
                  password: hash
                });
                newUser.save();
                reply({
                  id: user._id,
                  name: user.name,
                  handle: user.handle,
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
      path: '/login',
      config: {
        validate: {
          payload: Joi.object({
              handle: Joi.string().min(3).max(20).required(),
              password: Joi.string().alphanum().required()
          }).unknown(false)
        }
      },
      handler: function (request, reply) {
        var user = request.payload;
        User.find({handle: user.handle}, function(err, userFound) {
          if (!userFound.length) {
            reply("Invalid username.").code(404);
          } else {
            var existingUser = userFound[0];
            Bcrypt.compare(user.password, existingUser.password, function(err, res) {
              if (res) {
                var token = Uuid.v1();
                reply(token);
              } else {
                reply("Invalid password.").code(403);
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
      handler: function (request, reply) {
        reply('New message in new convo');
      }

    },
    {
      method: 'POST',
      path: '/moments/:id',
      handler: function (request, reply) {
        reply('New message in existing convo');
      }

    }
];
module.exports = routes;