// ROUTES FOR API
// =============================================================================

var express = require('express');
var router = express.Router();
var DbSpecs = require('../config.js');
var mongoose = require('mongoose');
mongoose.connect(DbSpecs);

// middleware to use for all requests
router.use(function (req, res, next) {
  console.log('Something is happening..');
  next(); // make sure we go to the next routes and don't stop here
});

router.get('/', function (req, res) {
    res.json({ message: 'Mom get the camera' });   
});

router.post('/signup', function (req, res) {
  var payload = req.body;
});

router.post('/login', function(req, res) {
  var payload = req.body;
});

router.get('/user/:id', function(req, res) {
  var payload = req.body;
});

// post to new conversation
router.post('/moments', function(req, res) {
  var payload = req.body;
})

  // get existing conversation
  .get('/moments/:id', function(req, res) {
    var payload = req.body;
  })
  
  // post to existing conversation
  .post('/moments/:id', function(req, res) {
    var payload = req.body;
  });

module.exports = router;