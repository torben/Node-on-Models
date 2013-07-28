
/*
 * GET home page.
 */

var app = require('../app');
var article = require('../app/models/article')

exports.index = function(req, res) {
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

  res.render('index', { title: 'Express' });
}