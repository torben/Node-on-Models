namespace 'views'

class tt.views.NavigationView extends tt.views.MainView
  template: _.template($('#navigation_template').html())
  tagName: 'li'
  events: {
    'click a': 'navigateTo'
  }

  initialize: (options = {}) ->
    super(options)

    @router = options.router if options


  navigateTo: (e) ->
    @router.navigate($(e.currentTarget).attr("href"), true)
    return false


  render: ->
    @$el.html @template(@model.toJSON())

    @