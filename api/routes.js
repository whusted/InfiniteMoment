var Joi = require('joi'),
    User = require('./models/user').User,
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
            username: Joi.string().min(3).max(20).required(),
            password: Joi.string().alphanum().min(8).max(50).required(),
            confirmPassword: Joi.string().alphanum().min(8).max(50).required(),
            phone: Joi.number().min(1000000).max(999999999999999).required() // So janky omg
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
  },

  {
    method: 'POST',
    path: '/friends',
    config: {
      validate: {
        payload: Joi.object({
            Authorization: Joi.string().required(),
            newFriend: Joi.string().required()
        }).unknown(false)
      }
    },
    handler: users.addFriend
  },

  {
    method: 'GET',
    path: '/friends',
    handler: users.getFriends
  }

];
module.exports = routes;