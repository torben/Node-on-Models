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
    $(".nav").html @navigationViewController.navigationView.render().el

    @footerView = new tt.views.FooterView
    $(".footer").html @footerView.render().el

    remoteDataHandler = new tt.helpers.RemoteDataHandler()
    remoteDataHandler.observe "articles", @articles
    remoteDataHandler.observe "navigations", @navigations

    Backbone.history.on "route", (router, path) =>
      window.setTimeout ->
        window.scrollTo 0, 1 if $.os.ios
      ,25
  

  index: ->
    @navigate "articles/home", true


  article: (permalink) ->
    @navigations.getModelBy 'permalink', permalink, (navigation) =>
      @articles.getModelBy 'navigation_id', navigation.id, (model) =>
        document.title = model.get "title"

        view = new tt.views.ArticleView(model: model)
        @navigationViewController.setCurrentNavigation navigation
        #@navigationViewController.setView view
        @navigationViewController.pushView view