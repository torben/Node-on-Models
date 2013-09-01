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


  pushView: (view, effect = "fade") ->
    switch effect
      when "bounce"
        effectIn = "bounceInLeft"
        effectOut = "bounceOutRight"
        effectTimeout = 300
      when "fade"
        effectIn = "fadeIn"
        effectOut = "fadeOut"
        effectTimeout = 1

    model = new Backbone.Model(view: view)

    $(".main-container").prepend view.render().$el
    view.$el.hide()

    if @collection.length > 1
      for i in [0..@collection.length-1]
        oldModel = @collection.models[0]
        continue unless oldModel?
        oldView = oldModel.get "view"
        @removeModel(oldModel)
    else if @collection.length == 1
      oldModel = @collection.models[0]
      oldView = oldModel.get "view"
      oldView.$el.removeClass(effectIn).addClass(effectOut)
      window.setTimeout (=> @removeModel(oldModel)), 1100

    @collection.add model

    timeout = if @collection.length > 1 then effectTimeout else 1

    window.setTimeout =>
      view.$el.show()
      view.$el.addClass(effectIn) if @collection.length > 1
    , timeout

