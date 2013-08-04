
/**
 * Module dependencies.
 */

var express = require('express')
  , routes = require('./routes/index')
  , http = require('http')
  , path = require('path')
  , sass = require("node-sass");

var app = express();

app.use(sass.middleware({
  src:  __dirname + '/app/assets',
  dest: path.join(__dirname, 'public'),
  debug: true
}));

// all environments
app.set('port', process.env.PORT || 3000);
app.set('views', __dirname + '/views');
app.set('view engine', 'jade');
app.use(express.favicon(__dirname + '/public/favicon.ico'));
app.use(express.logger('dev'));
app.use(express.bodyParser());
app.use(express.methodOverride());
app.use(express.cookieParser('sjdflajslfj4kljlsafjlsdf$%Q$SDFJKASDFjaksdfl2$%WEhere'));
app.use(express.session());
app.use(express.static(path.join(__dirname, 'public')));
app.use(app.router);

// development only
if ('development' == app.get('env')) {
  app.use(express.errorHandler());
}

app.get('*', routes.index);

var server = http.createServer(app);

server.listen(app.get('port'), function() {
  console.log('Express server listening on port ' + app.get('port'));
});

var sio = require('./app/observer/socketio')(server)

//exports.io = io;