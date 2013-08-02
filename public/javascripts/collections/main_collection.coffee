namespace 'collections'

class tt.collections.MainCollection extends Backbone.Collection
  waitingQueue: []

  initialize: ->
    @on 'add', @modelAdded


  modelAdded: (model) ->
    for queueEntry in @waitingQueue
      queueEntry.callback(model) if queueEntry.id == model.id


  getModel: (id, callback) ->
    model = @get(id)
    return callback(model) if model?

    for queueEntry in @waitingQueue
      return if queueEntry.id = id

    @waitingQueue.push id: id, callback, callback