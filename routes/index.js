
/*
 * GET home page.
 */

var app = require('../app');
var Article = require('../app/models/article')
var Navigation = require('../app/models/navigation')

exports.index = function(req, res) {
  var io = app.io;
  io.sockets.on('connection', function (socket) {
    Article.all(function(err, articles) {
      articles.forEach(function(article) {
        socket.emit('articles', { article: article.toJSON() });
      });
    });

    Navigation.all(function(err, navigations) {
      navigations.forEach(function(navigation) {
        socket.emit('navigations', { navigation: navigation.toJSON() });
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