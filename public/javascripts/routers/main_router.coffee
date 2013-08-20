namespace "routers"

class tt.routers.MainRouter extends Backbone.Router
  routes:
    "articles/:permalink":          "article"
    "articles/projects/:permalink": "article"
    "*page":                        "index" # catch all


  initialize: ->
    @navigationView = new tt.views.NavigationView()
    @articles = new tt.collections.Articles()
    @navigations = new tt.collections.Navigations()

    @navigationViewController = new tt.viewControllers.NavigationViewController(navigations: @navigations, router: @)
    $(".nav").html(@navigationViewController.navigationView.render().el)

    remoteDataHandler = new tt.helpers.RemoteDataHandler()
    remoteDataHandler.observe "articles", @articles
    remoteDataHandler.observe "navigations", @navigations


  index: ->
    @navigate "articles/home", true


  article: (permalink) ->
    @navigations.getModelBy 'permalink', permalink, (navigation) =>
      @articles.getModelBy 'navigation_id', navigation.id, (model) =>
        document.title = model.get "title"

        view = new tt.views.ArticleView(model: model)
        @navigationViewController.setCurrentNavigation navigation
        @navigationViewController.setView view