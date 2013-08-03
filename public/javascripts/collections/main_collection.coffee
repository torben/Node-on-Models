namespace 'collections'

class tt.collections.MainCollection extends Backbone.Collection
  waitingQueue: []

  initialize: ->
    @on 'add', @modelAdded


  modelAdded: (model) ->
    for queueEntry in @waitingQueue
      queueEntry.callback(model) if model.get(queueEntry.type) == queueEntry.value


  getModel: (id, callback) ->
    @getModelBy 'id', id, callback


  getModelBy: (type, value, callback) ->
    obj = {}
    obj[type] = value

    model = @where(obj)[0]
    return callback(model) if model?

    for queueEntry in @waitingQueue
      return if queueEntry.type == type && queueEntry.value == value

    @waitingQueue.push type: type, value: value, callback: callback
