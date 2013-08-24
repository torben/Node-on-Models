namespace 'views'

class tt.views.NavigationView extends tt.views.MainView
  template: _.template($('#navigation_item_template').html())
  tagName: 'li'
  model: tt.models.Navigation

  initialize: (options = {}) ->
    super(options)

    @router = options.router if options

    _.bindAll @, 'changeCurrent'
    @model.on 'change:current', @changeCurrent if options.model?


  changeCurrent: (model) ->
    if model.get("current") == true
      @$el.addClass("current")
    else
      @$el.removeClass("current")


  render: ->
    @$el.html @template(@model.toJSON())

    @