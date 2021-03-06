namespace "viewControllers"

class tt.viewControllers.NavigationViewController
  navigationView: null
  collection: null

  constructor: (options={}) ->
    @navigations = options.navigations
    @router = options.router

    @collection = new Backbone.Collection

    @navigationView = new tt.views.NavigationsView collection: @navigations, router: @router


  pushView: (view) ->
    removeModel = (model) =>
      @collection.remove(model)
      model.get("view").remove()

    model = new Backbone.Model(view: view)
    @collection.add model

    timeout = if @collection.length > 1 then 300 else 1

    window.setTimeout =>
      view.render().$el.insertAfter $("#nav-begin-line")
      view.$el.addClass("bounceInLeft") if @collection.length > 1

      @navigationView.setActive(view.model.get("navigation_id"))
    , timeout

    if @collection.length > 1
      for i in [@collection.length-1..0]
        model = @collection.models[i]
        oldView = model.get "view"
        if i == @collection.length - 2
          oldView.$el.removeClass("bounceInLeft").addClass("bounceOutRight")
          window.setTimeout (=>removeModel(model)), 1300
        else if i < @collection.length - 3
          @removeModel(model)
