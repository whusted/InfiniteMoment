var User = require('../models/user').User,
    Bcrypt = require('bcrypt');

var accountFuncs = {
    signup: function(request, reply) {
      var user = request.payload;
      if (user.password !== user.confirmPassword) {
        reply("Passwords must match").code(400);
      }

      User.findOne({username: user.username}, function(err, found) {
        if (found) {
          reply("Username " + user.username + " already exists").code(409);
        } else {
          Bcrypt.genSalt(10, function(err, salt) {
            Bcrypt.hash(user.password, salt, function(err, hash) {
              var newUser = new User({
                name: user.name,
                username: user.username,
                password: hash
              });
              newUser.save();
              reply({
                id: user._id,
                name: user.name,
                username: user.username,
                response: "Created a new user"
              });
            });
          });
        }
      });
    }
};

module.exports = accountFuncs;