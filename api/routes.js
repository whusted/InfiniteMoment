var Hapi = require('hapi'),
    Joi = require('joi'),
    User = require('./models/user').User,
    Moment = require('./models/moment').Moment,
    Bcrypt = require('bcrypt'),
    Uuid = require('uuid'),
    accounts = require('./helpers/accounts');

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
  // TODO: delete user account
];
module.exports = routes;