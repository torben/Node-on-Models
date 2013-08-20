namespace 'views'

class tt.views.NavigationView extends tt.views.MainView
  template: _.template($('#navigation_item_template').html())
  tagName: 'li'
  model: tt.models.Navigation

  initialize: (options = {}) ->
    super(options)

    @router = options.router if options

    _.bindAll @, 'changeActive'
    @model.on 'change:active', @changeActive if options.model?


  changeActive: (model) ->
    if model.get("active") == true
      @$el.addClass("active")
    else
      @$el.removeClass("active")


  render: ->
    @$el.html @template(@model.toJSON())

    @