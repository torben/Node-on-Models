namespace 'views'

class tt.views.NavigationsView extends tt.views.MainView
  lastClassName: null
  tagName: 'div'
  className: 'container'
  collection: tt.collections.Navigations
  template: _.template($('#navigation_template').html())
  views: []
  model: null

  events:
    'click .nav-toggle': 'toggleNavigation'
    'click .links a': 'closeNavigation'


  initialize: (options) ->
    super options

    _.bindAll @, 'addAll', 'addOne'

    @router = options.router

    @collection.on 'reset', @addAll
    @collection.on 'add', @addOne

    @model = new tt.models.MainModel


  closeNavigation: (e) ->
    if @$('.links').hasClass 'fadeIn'
      $("body").removeClass "no-overflow"
      @$('.links').removeClass('fadeIn').addClass('fadeOut')


  showNavigation: (e) ->
    unless @$('.links').hasClass 'fadeIn'
      $("body").addClass "no-overflow"
      @$('.links').removeClass('fadeOut').addClass('fadeIn')


  toggleNavigation: (e) ->
    window.scrollTo 0,0
    @$('.links').show()
    if @$('.links').hasClass 'fadeIn'
      @closeNavigation(e)
    else
      @showNavigation(e)


  setCurrentClass: (className) ->
    @$el.removeClass @lastClassName if @lastClassName?
    @lastClassName = className
    
    @$el.addClass className


  addAll: ->
    @collection.each(@addOne)


  addOne: (model) ->
    return if model.get("active") == 0 || model.get("position") == 0 || !model.get("position")?

    view = new tt.views.NavigationView(model: model, router: @router)
    @views.push(view) if @views.indexOf(view) == -1

    @$(".links").append(view.render().el)
    if @$el.find("ul.links li").length == 1
      view.$el.addClass "first"


  setActive: (id) ->
    for view in @views
      view.model.set("active", view.model.get("id") == id)


  render: ->
    @$el.html(@template())

    @