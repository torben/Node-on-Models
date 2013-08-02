namespace "routers"

class tt.routers.MainRouter extends Backbone.Router
  routes:
    "/articles/:id":  "article"
    "*page":          "index" # catch all


  initialize: ->
    @navigationView = new tt.views.NavigationView()
    @articles = new tt.collections.Articles()
    @navigations = new tt.collections.Navigations()

    @navigationsView = new tt.views.NavigationsView(collection: @navigations)
    $(".navigations").html(@navigationsView.render().el)

    remoteDataHandler = new tt.helpers.RemoteDataHandler()
    remoteDataHandler.observe "articles", @articles
    remoteDataHandler.observe "navigations", @navigations


  index: ->
    console.log "called!"


  article: (id) ->
    @articles.getModel id, (model) ->
      console.log model
      