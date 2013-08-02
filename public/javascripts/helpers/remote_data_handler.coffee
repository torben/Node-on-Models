namespace 'helpers'

class tt.helpers.RemoteDataHandler
  socket: null

  constructor: ->
    @socket = io.connect('http://localhost')


  observe: (channel, collection) ->
    console.log "hmmm: #{channel}"
    @socket.on channel, (data) -> collection.add(data)

    @socket.emit 'observe', {collection: channel}