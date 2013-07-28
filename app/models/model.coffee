pluralize = require('pluralize')
DB = require("../../db/db")

class Model
  @className: 'Model'
  @db: new DB()

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


  constructor: ->
    @defineProperties()

    @


  get: (field) ->
    @["_#{field}"]


  set: (field, value) ->
    @["_#{field}"] = value


  defineProperties: ->
    @constructor.fields (err, fields) =>
      for field in fields
        Object.defineProperty @, field, 
          get: => @get(field)
          set: (value) => @set(field, value)
          enumerable: true


  all: ->
    

Model.fields()

module.exports = Model