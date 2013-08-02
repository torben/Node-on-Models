// Generated by CoffeeScript 1.6.3
var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

namespace('collections');

tt.collections.MainCollection = (function(_super) {
  __extends(MainCollection, _super);

  function MainCollection() {
    _ref = MainCollection.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  MainCollection.prototype.waitingQueue = [];

  MainCollection.prototype.initialize = function() {
    return this.on('add', this.modelAdded);
  };

  MainCollection.prototype.modelAdded = function(model) {
    var queueEntry, _i, _len, _ref1, _results;
    _ref1 = this.waitingQueue;
    _results = [];
    for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
      queueEntry = _ref1[_i];
      if (queueEntry.id === model.id) {
        _results.push(queueEntry.callback(model));
      } else {
        _results.push(void 0);
      }
    }
    return _results;
  };

  MainCollection.prototype.getModel = function(id, callback) {
    var model, queueEntry, _i, _len, _ref1;
    model = this.get(id);
    if (model != null) {
      return callback(model);
    }
    _ref1 = this.waitingQueue;
    for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
      queueEntry = _ref1[_i];
      if (queueEntry.id = id) {
        return;
      }
    }
    return this.waitingQueue.push({
      id: id
    }, callback, callback);
  };

  return MainCollection;

})(Backbone.Collection);
