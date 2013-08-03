namespace 'views'

class tt.views.NavigationsView extends tt.views.MainView
  tagName: 'ul'
  className: 'right'
  collection: tt.collections.Navigations
  views: []

  initialize: (options) ->
    super options

    _.bindAll @, 'addAll', 'addOne'

    @router = options.router

    @collection.on 'reset', @addAll
    @collection.on 'add', @addOne


  addAll: ->
    @collection.each(@addOne)


  addOne: (model) ->
    view = new tt.views.NavigationView(model: model, router: @router)
    @views.push(view) if @views.indexOf(view) == -1

    @$el.append(view.render().el)
    if @$el.find("li").length == 1
      view.$el.addClass "first"


  setActive: (id) ->
    for view in @views
      view.model.set("active", view.model.get("id") == id)


  render: ->
    @$el.html("")

    @