// Generated by CoffeeScript 1.6.3
var Article, Model, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Model = require('./model');

Article = (function(_super) {
  __extends(Article, _super);

  function Article() {
    _ref = Article.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Article.className = 'Article';

  return Article;

})(Model);

Article.fields();

module.exports = Article;
