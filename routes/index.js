
/*
 * GET home page.
 */

var app = require('../app');
var Article = require('../app/models/article')

exports.index = function(req, res) {
  /*
  var io = app.io;
  io.sockets.on('connection', function (socket) {
    socket.emit('news', { hello: 'world' });
    setTimeout(function() {
      socket.emit('news', { hello: 'world2' });
    }, 1000)
    socket.on('my other event', function (data) {
      console.log(data);
    });
  });
  */

  // Article.create({author_id: 2, title: 'Damn right', body: 'Sometimes!'}, function() {})
  // Article.create({author_id: 1, title: 'MIIIES', body: 'geilo!'}, function() {})

  var articles;
  articles = Article.all(function(err) {
    res.render('index', { title: 'Express', articles: articles })
  });
}