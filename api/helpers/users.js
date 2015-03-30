var User = require('../models/user').User,
    tokens = require('./tokens'),
    auth = require('./authentication');

var userFuncs = {
  searchForUsers: function (request, reply) {
    User.findOne({authToken: request.headers.authorization}, function (err, existingUser) {
      if (auth.checkAuthToken(existingUser, reply)) {
        var searchString = request.headers.search;
        User.find({username: new RegExp('^' + searchString + '.*$', "i")}, function (err, users) {
          if (!users.length) {
            reply("No users found.");
          } else {
            var usersArr = [];
            var index = 0;
            users.forEach(function (user) {
              usersArr[index] = user.username;
              index++;
            });
            reply(usersArr);
          }
        });
      }
    });
  },

  addFriend: function (request, reply) {

  }

};

module.exports = userFuncs;