namespace "viewControllers"

class tt.viewControllers.NavigationViewController
  navigationView: null
  collection: null
  oldPermalink: null

  constructor: (options={}) ->
    @navigations = options.navigations
    @router = options.router

    @collection = new Backbone.Collection

    @navigationView = new tt.views.NavigationsView collection: @navigations, router: @router


  setCurrentNavigation: (currentNavigation) ->
    @navigationView.setCurrentClass currentNavigation.get "permalink"

    $("body").removeClass(@oldPermalink) if @oldPermalink?
    @oldPermalink = currentNavigation.get "permalink"

    $("body").addClass @oldPermalink


  get: (field, options) ->
    @navigationView.model.get field, options


  set: (field, options) ->
    @navigationView.model.set field, options


  setView: (view) ->
    @collection.each (model) =>
      oldView = model.get "view"
      @removeModel(model)

    model = new Backbone.Model(view: view)
    @collection.add model

    $(".main-container").append view.render().$el
    #view.$el.addClass "animated fadeIn"


  removeModel: (model) ->
    @collection.remove(model)
    model.get("view").remove()


  pushView: (view) ->
    model = new Backbone.Model(view: view)
    @collection.add model

    timeout = if @collection.length > 1 then 300 else 1
    #timeout = 1

    window.setTimeout =>
      $(".main-container").prepend view.render().$el
      view.$el.addClass("bounceInLeft") if @collection.length > 1

      @navigationView.setActive(view.model.get("navigation_id"))
    , timeout

    if @collection.length > 1
      for i in [@collection.length-1..0]
        model = @collection.models[i]
        oldView = model.get "view"
        if i == @collection.length - 2
          oldView.$el.removeClass("bounceInLeft").addClass("bounceOutRight")
          window.setTimeout (=> @removeModel(model)), 1300
          #@removeModel(model)
        else if i < @collection.length - 3
          @removeModel(model)
