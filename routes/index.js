
/*
 * GET home page.
 */

var app = require('../app');
var Article = require('../app/models/article')
var Navigation = require('../app/models/navigation')

exports.index = function(req, res) {
  res.render('welcome/index', { 
    title: 'Express'
  })
}