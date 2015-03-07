// ROUTES FOR API
var routes = [
    {
      method: 'POST',
      path: '/signup',
      handler: function (request, reply) {
          reply('New user bruh');
      }
    },

    {
      method: 'POST',
      path: '/login',
      handler: function (request, reply) {
        reply('Login');
      }

    },
    {
      method: 'GET',
      path: '/user/:id',
      handler: function (request, reply) {
        reply('User', reply.params.id);
      }

    },
    // post to new conversation
    {
      method: 'POST',
      path: '/moments',
      handler: function (request, reply) {
        reply('New message in new convo');
      }

    },
    {
      method: 'POST',
      path: '/moments/:id',
      handler: function (request, reply) {
        reply('New message in existing convo');
      }

    }
];
module.exports = routes;