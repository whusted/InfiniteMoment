// server.js

// BASE SETUP
// =============================================================================

var express = require('express');
var app = express();
var bodyParser = require('body-parser');
var routes = require('./routes.js');

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

var port = process.env.PORT || 7777;

// REGISTER OUR ROUTES -------------------------------
app.use('/api', routes);

// START THE SERVER
// =============================================================================
app.listen(port);
console.log('Working on port ' + port);