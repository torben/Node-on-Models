namespace "routers"

class tt.routers.MainRouter extends Backbone.Router
  routes:
    "articles/:id":  "article"
    "*page":          "index" # catch all


  initialize: ->
    @navigationView = new tt.views.NavigationView()
    @articles = new tt.collections.Articles()
    @navigations = new tt.collections.Navigations()

    @navigationViewController = new tt.viewControllers.NavigationViewController(navigations: @navigations, router: @)
    $(".navigations").html(@navigationViewController.navigationView.render().el)

    remoteDataHandler = new tt.helpers.RemoteDataHandler()
    remoteDataHandler.observe "articles", @articles
    remoteDataHandler.observe "navigations", @navigations


  index: ->
    #console.log "called!"


  article: (permalink) ->
    @navigations.getModelBy 'permalink', permalink, (navigation) =>
      @articles.getModel navigation.id, (model) =>
        view = new tt.views.ArticleView(model: model)
        @navigationViewController.pushView(view)