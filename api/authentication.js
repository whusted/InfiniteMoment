var Joi = require('joi'),
    User = require('./models/user').User;

exports.login = {
    validate: {
        payload: {
            email: Joi.string().email().required(),
            password: Joi.string().required()
        }
    },
    handler: function (request, reply) {
        reply('Your e-mail is' + request.payload.email);
    }
}

exports.register = {
    validate: {
        payload: {
            email: Joi.string().email().required(),
            password: Joi.string().required()
        }
    },
    handler: function(request, reply) {
        reply('Your e-mail is' + request.payload.email);
    }
}