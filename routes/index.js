
/*
 * GET home page.
 */

var app = require('../app');
var Article = require('../app/models/article')

exports.index = function(req, res) {
  var io = app.io;
  io.sockets.on('connection', function (socket) {
    Article.all(function(err, articles) {
      articles.forEach(function(article) {
        socket.emit('articles', { article: article.toJSON() });
      });
    });
    socket.on('my other event', function (data) {
      console.log(data);
    });
  });

  res.render('welcome/index', { 
    title: 'Express'
  })
}