module.exports = (server) ->
  io = require('socket.io').listen(server)
  Article = require('../models/article')
  Navigation = require('../models/navigation')

  io.sockets.on 'connection', (socket) ->
    socket.on 'observe', (msg) ->
      switch msg.collection
        when "articles"
          console.log("1x")
          Article.all (err, articles) ->
            console.log articles.map (article) -> return article.id
            return if err?

            articles.forEach (article) ->
              console.log(article.id)
              socket.emit 'articles', article.toJSON()
      
        when "navigations"
          Navigation.all (err, navigations) ->
            return if err?
            navigations.forEach (navigation) ->
              socket.emit 'navigations', navigation.toJSON()

  io