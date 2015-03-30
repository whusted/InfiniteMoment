var User = require('../models/user').User,
    tokens = require('./tokens');

var userFuncs = {
  searchForUsers: function (request, reply) {
    User.findOne({authToken: request.headers.authorization}, function (err, existingUser) {
      if (!existingUser) {
        reply("Invalid auth token.").code(401);
      } else if (tokens.isExpired(existingUser.tokenExpiration)) {
        tokens.setTokenToNull(existingUser);
        existingUser.save();
        reply("Auth token has expired.").code(401);
      } else {
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
    })
  }

};

module.exports = userFuncs;