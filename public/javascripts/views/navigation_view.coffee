namespace 'views'

class tt.views.NavigationView extends tt.views.MainView
  template: _.template($('#navigation_template').html())
  tagName: 'li'

  initialize: (options) ->
    super(options)


  render: ->
    @$el.html @template(@model.toJSON())

    @