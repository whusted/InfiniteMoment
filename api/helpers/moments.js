var User = require('../models/user').User,
    Moment = require('../models/moment').Moment,
    tokens = require('./tokens'),
    auth = require('./authentication');

var momentFuncs = {
  createMoment: function (request, reply) {
    var moment = request.payload;
    User.findOne({authToken: moment.Authorization}, function (err, existingUser) {
      if (auth.checkAuthToken(existingUser, reply)) {
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
      User.findOne({authToken: request.headers.authorization}, function (err, existingUser) {
        if (auth.checkAuthToken(existingUser, reply)) {
          var username = existingUser.username;
          Moment.find({ author: username }, function (err, moments) {
            reply(moments);
          });
        }
      });
    },

    getMomentsFeed: function (request, reply) {
      User.findOne({authToken: request.headers.authorization}, function (err, user) {
        if (auth.checkAuthToken(user, reply)) {
          var username = user.username;
          Moment.find({ recipients: username }, function (err, moments) {
            var viewableMoments = [];
            var index = 0;
            moments.forEach(function (moment) {
              var currentTime = new Date().getTime();
              var deliveryDateInMillis = new Date(moment.deliveryDate).getTime();
              if (currentTime >= deliveryDateInMillis) {
                viewableMoments[index] = moment;
                index++;
              }
            });
            reply(viewableMoments);
          });
        }
      });
    }

};

module.exports = momentFuncs;