var Hapi = require('hapi'),
    Joi = require('joi'),
    User = require('./models/user').User,
    Moment = require('./models/moment').Moment,
    Bcrypt = require('bcrypt'),
    Uuid = require('uuid'),
    accounts = require('./helpers/accounts'),
    moments = require('./helpers/moments'),
    users = require('./helpers/users');

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
    handler: accounts.signup
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
    handler: accounts.login
  },

  {
    method: 'DELETE',
    path: '/sessions',
    handler: accounts.logout
  },

  {
    method: 'GET',
    path: '/user/:id',
    handler: function (request, reply) {
      reply('User', reply.params.id);
    }

  },

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
    handler: moments.createMoment
  },
  {
    method: 'GET',
    path: '/moments',
    handler: moments.getMomentsCreatedByUser
  },

  {
    method: 'GET',
    path: '/momentsFeed',
    handler: moments.getMomentsFeed
  },

  {
    method: 'GET',
    path: '/users',
    handler: users.searchForUsers
  }
  // TODO: search users
  // TODO: add user to friend list
  // TODO: get user's friend list
  // TODO: delete user account
];
module.exports = routes;