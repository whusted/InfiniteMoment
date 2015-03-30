var User = require('../models/user').User,
    tokens = require('./tokens');

var authentication = {
  checkAuthToken: function (user, reply) {
    if (!user) {
        reply("Invalid auth token.").code(401);
        return false;
      } else if (tokens.isExpired(user.tokenExpiration)) {
        tokens.setTokenToNull(user);
        user.save();
        reply("Auth token has expired.").code(401);
        return false;
      }
      return true;
  } 
};

module.exports = authentication;