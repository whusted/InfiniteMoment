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
        // grab string from header
        var searchString = request.headers.search;
        // put string into regex
        User.find({username: new RegExp('(?i)'+ searchString + '.*')}, function (err, users) {
          if (!users.length) {
            // No users found
          } else {
            reply(users);
          }
        });
      }
    })
  }

};

module.exports = userFuncs;