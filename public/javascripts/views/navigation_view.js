// Generated by CoffeeScript 1.6.3
var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

namespace('views');

tt.views.NavigationView = (function(_super) {
  __extends(NavigationView, _super);

  function NavigationView() {
    _ref = NavigationView.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  NavigationView.prototype.initialize = function(options) {
    return NavigationView.__super__.initialize.call(this, options);
  };

  NavigationView.prototype.render = function() {
    return this;
  };

  return NavigationView;

})(tt.views.MainView);
