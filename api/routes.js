var Hapi = require('hapi'),
    Joi = require('joi'),
    User = require('./models/user').User;

var routes = [
    {
      method: 'POST',
      path: '/signup',
      config: {
        validate: {
          payload: {
              username: Joi.string().min(3).max(20).required(),
              password: Joi.string().alphanum().required()
          }
        }
      },
      handler: function(request, reply) {
          reply('Your e-mail is' + request.payload.email);
      }
    },

    {
      method: 'POST',
      path: '/login',
      handler: function (request, reply) {
        reply('Login');
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