// Generated by CoffeeScript 1.6.3
var DB, Model, pluralize;

pluralize = require('pluralize');

DB = require("../../db/db");

Model = (function() {
  Model.className = 'Model';

  Model.db = new DB();

  Model.tableName = function() {
    return pluralize(this.className.toLowerCase());
  };

  Model.fields = function(callback) {
    var _this = this;
    if (this._fields != null) {
      if (callback != null) {
        callback.call(this, null, this._fields);
      }
      return this._fields;
    }
    return this.db.loadFieldsFor(this.tableName(), function(err, fields) {
      if (err != null) {
        callback.call(_this, err);
        return;
      }
      _this._fields = fields;
      if (callback != null) {
        return callback.call(_this, null, fields);
      }
    });
  };

  Model.klass = function() {
    return this;
  };

  function Model() {
    this.defineProperties();
    this;
  }

  Model.prototype.get = function(field) {
    return this["_" + field];
  };

  Model.prototype.set = function(field, value) {
    return this["_" + field] = value;
  };

  Model.prototype.defineProperties = function() {
    var _this = this;
    return this.constructor.fields(function(err, fields) {
      var field, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = fields.length; _i < _len; _i++) {
        field = fields[_i];
        _results.push(Object.defineProperty(_this, field, {
          get: function() {
            return _this.get(field);
          },
          set: function(value) {
            return _this.set(field, value);
          },
          enumerable: true
        }));
      }
      return _results;
    });
  };

  Model.prototype.all = function() {};

  return Model;

})();

Model.fields();

module.exports = Model;
