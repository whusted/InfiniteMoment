var User = require('../models/user').User,
    Moment = require('../models/moment').Moment,
    tokens = require('./tokens');

var momentFuncs = {
  createMoment: function (request, reply) {
    var moment = request.payload;
    User.findOne({authToken: moment.Authorization}, function(err, existingUser) {
      if (!existingUser) {
        reply("Invalid auth token.").code(401);
      } else if (tokens.isExpired(existingUser.tokenExpiration)) {
        tokens.setTokenToNull(existingUser);
        existingUser.save();
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
  },

  getMomentsCreatedByUser: function (request, reply) {
      User.findOne({authToken: request.headers.authorization}, function(err, existingUser) {
        if (!existingUser) {
          reply("Invalid auth token.").code(401);
        } else if (tokens.isExpired(existingUser.tokenExpiration)) {
          tokens.setTokenToNull(existingUser);
          existingUser.save();
          reply("Auth token has expired.").code(401);
        } else {
          var username = existingUser.username;
          Moment.find({ author: username }, function(err, moments) {
            reply(moments);
          });
        }
      });
    },

    getMomentsFeed: function (request, reply) {
      User.findOne({authToken: request.headers.authorization}, function(err, existingUser) {
        if (!existingUser) {
          reply("Invalid auth token.").code(401);
        } else if (tokens.isExpired(existingUser.tokenExpiration)) {
          tokens.setTokenToNull(existingUser);
          existingUser.save();
          reply("Auth token has expired.").code(401);
        } else {
          var username = existingUser.username;
          Moment.find({ recipients: username }, function(err, moments) {
            reply(moments);
          });
        }
      });
    }

};

module.exports = momentFuncs;