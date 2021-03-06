// Generated by CoffeeScript 1.6.3
var DB, async, db, fs, sqlite3;

fs = require('fs');

sqlite3 = require('sqlite3').verbose();

async = require('async');

DB = (function() {
  DB.prototype.migrationDir = "./db/migrations";

  DB.prototype.checkTableSql = "SELECT name FROM sqlite_master WHERE type='table' AND name=?;";

  function DB(env, withMigrations) {
    if (env == null) {
      env = 'development';
    }
    if (withMigrations == null) {
      withMigrations = false;
    }
    this.database = "./db/database_" + env + ".sqlite";
    if (!fs.existsSync(this.database)) {
      this.createDatabase();
    }
    this.db = this.openDatabase();
  }

  DB.prototype.createDatabase = function() {
    var file;
    if (fs.existsSync(this.database)) {
      return;
    }
    file = fs.openSync(this.database, 'w');
    return fs.close(file);
  };

  DB.prototype.openDatabase = function() {
    if (this.db != null) {
      return this.db;
    }
    return new sqlite3.Database(this.database);
  };

  DB.prototype.loadFieldsFor = function(tableName, callback) {
    var sql;
    sql = "PRAGMA table_info(" + tableName + ");";
    return this.db.all(sql, function(err, result) {
      if (err != null) {
        callback.call(this, err);
      }
      return callback.call(this, null, result.map(function(obj) {
        return obj.name;
      }));
    });
  };

  DB.prototype.doMigrations = function(files) {
    var fns, parseMigrationFile, _file, _i, _len,
      _this = this;
    if (files == null) {
      files = [];
    }
    if (files.length === 0) {
      files = fs.readdirSync(this.migrationDir);
    }
    parseMigrationFile = function() {
      var callback, file, index, migration;
      if (typeof arguments[0] === "function") {
        callback = arguments[0];
        index = 0;
      } else {
        index = arguments[0];
        callback = arguments[1];
      }
      file = files[index];
      migration = require("../" + _this.migrationDir + "/" + file);
      return _this.executeMigration(migration, callback, index);
    };
    fns = [];
    for (_i = 0, _len = files.length; _i < _len; _i++) {
      _file = files[_i];
      fns.push(parseMigrationFile);
    }
    return async.waterfall(fns, function() {
      return console.log("Migration passed!");
    });
  };

  DB.prototype.executeMigration = function(migration, callback, index) {
    var sql,
      _this = this;
    if (callback == null) {
      callback = null;
    }
    if (index == null) {
      index = 0;
    }
    sql = "";
    switch (migration.action) {
      case "createTable":
        return this.db.get(this.checkTableSql, migration.tableName, function(err, row) {
          var field, _i, _len, _ref;
          if ((err != null) || (row != null)) {
            callback.call(_this, err, index + 1);
            return;
          }
          sql = "CREATE TABLE " + migration.tableName + "(id INTEGER PRIMARY KEY";
          _ref = migration.fields;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            field = _ref[_i];
            sql += "," + field.name + " ";
            sql += (function() {
              switch (field.type) {
                case "string":
                  return "VARCHAR(255)";
                case "integer":
                  return "INTEGER";
                case "text":
                  return "TEXT";
                case "boolean":
                  return "BOOLEAN";
                default:
                  throw new Error("Field type not supported.");
              }
            })();
          }
          sql += ");";
          return _this.db.run(sql, function() {
            if (callback != null) {
              return callback(null, index + 1);
            }
          });
        });
    }
  };

  DB.prototype.insertRow = function(tableName, fields, values, callback) {
    var i, sql, that;
    if (callback == null) {
      return;
    }
    sql = "INSERT INTO " + tableName + " (" + (fields.join(',')) + ") VALUES (" + ((function() {
      var _i, _ref, _results;
      _results = [];
      for (i = _i = 1, _ref = fields.length; 1 <= _ref ? _i <= _ref : _i >= _ref; i = 1 <= _ref ? ++_i : --_i) {
        _results.push('?');
      }
      return _results;
    })()) + ")";
    that = this;
    return this.db.run(sql, values, function(err) {
      if (err != null) {
        return callback.call(this, err);
      }
      if (this.lastID == null) {
        return callback.call(this, new Error('lastID not found'));
      }
      return that.findById(this.lastID, tableName, callback);
    });
  };

  DB.prototype.updateRow = function(tableName, id, fields, values, callback) {
    var field, sql,
      _this = this;
    if (callback == null) {
      return;
    }
    sql = "UPDATE " + tableName + " SET " + ((function() {
      var _i, _len, _results;
      _results = [];
      for (_i = 0, _len = fields.length; _i < _len; _i++) {
        field = fields[_i];
        _results.push(field + ' = ?');
      }
      return _results;
    })()) + " WHERE id = ?";
    values.push(id);
    return this.db.run(sql, values, function(err) {
      if (err != null) {
        return callback.call(_this, err);
      }
      return _this.findById(id, tableName, callback);
    });
  };

  DB.prototype.findById = function(id, tableName, callback) {
    var sql;
    if (callback == null) {
      return;
    }
    sql = "SELECT * FROM " + tableName + " where id = ?";
    return this.db.get(sql, [id], callback);
  };

  DB.prototype.loadAllFor = function(tableName, callback) {
    var sql;
    if (callback == null) {
      return;
    }
    sql = "SELECT * FROM " + tableName + " ORDER BY id";
    return this.db.all(sql, callback);
  };

  DB.prototype.where = function(condition, tableName, callback) {
    var key, sql, value, values;
    if (condition == null) {
      condition = {};
    }
    if (callback == null) {
      return;
    }
    sql = "SELECT * FROM " + tableName + " WHERE ";
    values = [];
    for (key in condition) {
      value = condition[key];
      values.push(value);
      sql += "" + key + " = ?";
    }
    sql += " ORDER BY id";
    return this.db.all(sql, values, callback);
  };

  return DB;

})();

db = null;

module.exports = function(env) {
  return db || (db = new DB(env));
};

if (require.main === module) {
  db = new DB('development');
  db.doMigrations();
}
