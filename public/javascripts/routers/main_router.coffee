namespace "routers"

class tt.routers.MainRouter extends Backbone.Router
  routes:
    "/articles/:id":  "article"
    "*page":          "index" # catch all


  initialize: ->
    @navigationView = new tt.views.NavigationView()


  index: ->
    console.log "called!"


  article: (id) ->
    console.log(id)