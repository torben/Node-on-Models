fs = require('fs')
sqlite3 = require('sqlite3').verbose()
async = require('async')


class DB
  migrationDir: "./db/migrations"
  checkTableSql: "SELECT name FROM sqlite_master WHERE type='table' AND name=?;"


  constructor: (env = 'development', withMigrations = false) ->
    @database = "./db/database_#{env}.sqlite"

    #@unlinkDatabase() if unlink
    @createDatabase() unless fs.existsSync(@database)
    @db = @openDatabase()


  #unlinkDatabase: ->
  #  fs.unlinkSync(@database) if fs.existsSync(@database)


  createDatabase: ->
    return if fs.existsSync(@database)

    file = fs.openSync(@database, 'w')
    fs.close(file)


  openDatabase: ->
    return @db if @db?
    new sqlite3.Database(@database)


  loadFieldsFor: (tableName, callback) ->
    sql = "PRAGMA table_info(#{tableName});"
    @db.all sql, (err, result) ->
      callback.call @, err if err?
      callback.call @, null, result.map((obj) -> obj.name )


  doMigrations: (files = []) ->
    files = fs.readdirSync(@migrationDir) if files.length == 0

    parseMigrationFile = =>
      if typeof arguments[0] == "function"
        callback = arguments[0]
        index = 0
      else
        index = arguments[0]
        callback = arguments[1]

      file = files[index]
      migration = require("../#{@migrationDir}/#{file}")
      @executeMigration(migration, callback, index)

    fns = []
    for _file in files
      fns.push(parseMigrationFile)

    async.waterfall fns, =>
      console.log "Migration passed!"


  executeMigration: (migration, callback = null, index = 0) ->
    sql = ""

    switch migration.action
      when "createTable"
        @db.get @checkTableSql, migration.tableName, (err, row) =>
          if err? || row?
            callback.call(@, err, index+1)
            return

          sql = "CREATE TABLE #{migration.tableName}(id INTEGER PRIMARY KEY"
          for field in migration.fields
            sql += ",#{field.name} "
            sql += switch field.type
              when "string"  then "VARCHAR(255)"
              when "integer" then "INTEGER"
              when "text"    then "TEXT"
              when "boolean" then "BOOLEAN"
              else throw new Error("Field type not supported.")

          sql += ");"
          @db.run sql, =>
            # TODO error handler?
            callback(null, index+1) if callback?


  insertRow: (tableName, fields, values, callback) ->
    sql = "INSERT INTO #{tableName} (#{fields.join(',')}) VALUES (#{'?' for i in [1..fields.length]})"
    that = @
    @db.run sql, values, (err) ->
      return callback.call(@, err) if err?
      return callback.call(@, new Error('lastID not found')) unless @lastID?

      that.findById @lastID, tableName, callback


  updateRow: (tableName, id, fields, values, callback) ->
    sql = "UPDATE #{tableName} SET #{field+' = ?' for field in fields} WHERE id = ?"
    values.push(id)
    @db.run sql, values, (err) =>
      return callback.call(@, err) if err?

      @findById id, tableName, callback


  findById: (id, tableName, callback) ->
    sql = "SELECT * FROM #{tableName} where id = ?"
    @db.get sql, [id], callback


  loadAllFor: (tableName, callback) ->
    sql = "SELECT * FROM #{tableName} ORDER BY id"
    @db.all sql, callback


db = null

module.exports = (env) ->
  db || db = new DB(env)


if require.main == module
  db = new DB('development')
  db.doMigrations()
