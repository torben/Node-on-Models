namespace 'helpers'

class tt.helpers.RemoteDataHandler
  socket: null

  constructor: ->
    @socket = io.connect tt.config.socketUrl


  observe: (channel, collection) ->
    @socket.on channel, (data) -> collection.add(data)

    @socket.emit 'observe', {collection: channel}