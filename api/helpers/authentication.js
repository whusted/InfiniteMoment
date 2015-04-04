var User = require('../models/user').User,
    tokens = require('./tokens');

var authentication = {
  checkAuthToken: function (user, reply) {
    if (!user) {
        return reply({
          error: "Invalid auth token.",
          message: "Invalid auth token."
        }).code(401);
      } else if (tokens.isExpired(user.tokenExpiration)) {
        tokens.setTokenToNull(user);
        user.save();
        return reply({
          error: "Auth token has expired.",
          message: "Auth token has expired."
        }).code(401);
      }
      return true;
  } 
};

module.exports = authentication;