module.exports = (server) ->
  io = require('socket.io').listen(server)
  Article = require('../models/article')
  Navigation = require('../models/navigation')

  io.sockets.on 'connection', (socket) ->
    socket.on 'observe', (msg) ->
      switch msg.collection
        when "articles"
          Article.all (err, articles) ->
            return if err?

            articles.forEach (article) ->
              socket.emit 'articles', article.toJSON()
      
        when "navigations"
          Navigation.all (err, navigations) ->
            return if err?
            navigations.forEach (navigation) ->
              socket.emit 'navigations', navigation.toJSON()

  io