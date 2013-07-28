fs = require('fs')
sqlite3 = require('sqlite3').verbose()
async = require('async')

class DB
  migrationDir: "./db/migrations"
  checkTableSql: "SELECT name FROM sqlite_master WHERE type='table' AND name=?;"


  constructor: (env = 'development', unlink = false, withMigrations = false) ->
    @database = "./db/database_#{env}.sqlite"

    fs.unlinkSync(@database) if fs.existsSync(@database) && unlink

    unless fs.existsSync(@database)
      file = fs.openSync(@database, 'w')
      fs.close(file)

    @db = new sqlite3.Database(@database)

    @doMigrations() if withMigrations


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
            callback.call(@, err)
            return

          sql = "CREATE TABLE #{migration.tableName}(id INTEGER PRIMARY KEY"
          for field in migration.fields
            sql += ",#{field.name} "
            sql += switch field.type
              when "string"  then "VARCHAR(255)"
              when "integer" then "INTEGER"
              when "text"    then "TEXT"
              else throw new Error("Field type not supported.")

          sql += ");"
          @db.run sql, =>
            # TODO error handler?
            callback(null, index+1) if callback?



module.exports = DB


if require.main == module
  db = new DB('development', true, true)
