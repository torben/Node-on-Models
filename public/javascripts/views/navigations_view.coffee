namespace 'views'

class tt.views.NavigationsView extends tt.views.MainView
  tagName: 'ul'
  className: 'right'
  collection: tt.collections.Navigations

  initialize: (options) ->
    super options

    _.bindAll @, 'addAll', 'addOne'

    @collection.on 'reset', @addAll
    @collection.on 'add', @addOne


  addAll: ->
    @collection.each(@addOne)


  addOne: (model) ->
    view = new tt.views.NavigationView(model: model)
    @$el.append(view.render().el)
    if @$el.find("li").length == 1
      view.$el.addClass "first"


  render: ->
    @$el.html("")

    @