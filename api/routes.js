var Hapi = require('hapi'),
    Joi = require('joi'),
    User = require('./models/user').User,
    Bcrypt = require('bcrypt');

var routes = [
    {
      method: 'POST',
      path: '/signup',
      config: {
        validate: {
          payload: {
              name: Joi.string().min(3).max(50).required(),
              handle: Joi.string().min(3).max(20).required(),
              password: Joi.string().alphanum().min(8).max(50).required(),
              confirmPassword: Joi.string().alphanum().min(8).max(50).required()
          }
        }
      },
      handler: function(request, reply) {
          var user = request.payload;
          if (user.password !== user.confirmPassword) {
            // TODO: Throw more formal error 400
            reply("Error: Password and Confirm Password must be the same.");
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
      }
    },

    {
      method: 'POST',
      path: '/login',
      config: {
        validate: {
          payload: {
              username: Joi.string().min(3).max(20).required(),
              password: Joi.string().alphanum().required()
          }
        }
      },
      handler: function (request, reply) {
        reply('User ' + request.payload.username + ' has logged in.');
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