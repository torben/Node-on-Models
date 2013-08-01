pluralize = require('pluralize')
DB = require("../../db/db")

class RecordNotFound extends Error

class Model
  @RecordNotFound: RecordNotFound
  @className: 'Model'
  @db: new DB()
  changedAttributes: []
  isNewRecord: true


  @tableName: ->
    pluralize(@className.toLowerCase())


  @fields: (callback) ->
    if @_fields?
      callback.call @, null, @_fields if callback?
      return @_fields

    @db.loadFieldsFor @tableName(), (err, fields) =>
      if err?
        callback.call @, err
        return

      @_fields = fields
      callback.call @, null, fields if callback?


  @klass: ->
    @


  @all: (callback) ->
    records = []
    @db.loadAllFor @tableName(), (err, rows) =>
      return callback.call @, err if err?

      for record in rows
        records.push new @(record)

      callback.call @, null, records

    records


  @find: (id, callback) ->
    model = new @

    @db.findById id, @tableName(), (err, row) =>
      return callback.call @, err if err?
      return callback.call @, new @RecordNotFound("Record with id #{id} not found") unless row?

      @isNewRecord = false

      model.set(key, value) for key, value of row
      model.changedAttributes = []

      callback.call @, null

    return model


  @create: (attributes, callback) ->
    new @(attributes).save callback


  constructor: (attributes = {}) ->
    @defineProperties()

    for key, attribute of attributes
      @[key] = attribute

    @


  save: (callback) ->
    saveCallback = (err, row) =>
      return callback.call @, err if err?

      changedFields = []
      for field, value of row
        @set(field, value)
        changedFields.push(field)
      @changedAttributes = []

      return callback.call @, null, changedFields


    values = []
    for field in @changedAttributes
      values.push @get(field)

    if @isNewRecord
      @constructor.db.insertRow @constructor.tableName(), @changedAttributes, values, saveCallback
    else
      @constructor.db.updateRow @constructor.tableName(), @id, @changedAttributes, values, saveCallback

    @



  get: (field) ->
    @["_#{field}"] || null


  set: (field, value) ->
    if @changedAttributes.indexOf(field) == -1 && @["_#{field}"] != value
      @changedAttributes.push(field)

    @["_#{field}"] = value


  defineProperties: ->
    @constructor.fields (err, fields) =>
      fields.forEach (field) =>
        Object.defineProperty @, field, 
          get: => @get(field)
          set: (value) => @set(field, value)
          enumerable: true


  toJSON: ->
    attributes = {}
    for key, value of @constructor.fields()
      attributes[value] = @get(value)
    attributes

    

Model.fields()

module.exports = Model