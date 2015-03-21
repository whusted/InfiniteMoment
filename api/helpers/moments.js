var User = require('../models/user').User,
    Moment = require('../models/moment').Moment;

var momentFuncs = {
  createMoment: function (request, reply) {
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

};

module.exports = momentFuncs;