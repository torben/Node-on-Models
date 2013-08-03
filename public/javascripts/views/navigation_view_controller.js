// Generated by CoffeeScript 1.6.3
namespace("viewControllers");

tt.viewControllers.NavigationViewController = (function() {
  NavigationViewController.prototype.navigationView = null;

  NavigationViewController.prototype.collection = null;

  function NavigationViewController(options) {
    if (options == null) {
      options = {};
    }
    this.navigations = options.navigations;
    this.router = options.router;
    this.collection = new Backbone.Collection;
    this.navigationView = new tt.views.NavigationsView({
      collection: this.navigations,
      router: this.router
    });
  }

  NavigationViewController.prototype.pushView = function(view) {
    var i, model, oldView, removeModel, _i, _ref, _results,
      _this = this;
    removeModel = function(model) {
      _this.collection.remove(model);
      return model.get("view").remove();
    };
    model = new Backbone.Model({
      view: view
    });
    this.collection.add(model);
    $('.main-container').prepend(view.render().el);
    if (this.collection.length > 1) {
      view.$el.addClass("bounceInLeft");
    }
    if (this.collection.length > 1) {
      _results = [];
      for (i = _i = _ref = this.collection.length - 1; _ref <= 0 ? _i <= 0 : _i >= 0; i = _ref <= 0 ? ++_i : --_i) {
        model = this.collection.models[i];
        oldView = model.get("view");
        if (i === this.collection.length - 2) {
          oldView.$el.removeClass("bounceInLeft").addClass("bounceOutRight");
          _results.push(window.setTimeout((function() {
            return removeModel(model);
          }), 1000));
        } else if (i < this.collection.length - 3) {
          _results.push(this.removeModel(model));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    }
  };

  return NavigationViewController;

})();
