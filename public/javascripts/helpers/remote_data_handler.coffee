namespace 'helpers'

class tt.helpers.RemoteDataHandler
  socket: null

  constructor: ->
    @socket = io.connect('http://localhost')


  observe: (channel, collection) ->
    @socket.on channel, (data) -> collection.add(data)

    @socket.emit 'observe', {collection: channel}