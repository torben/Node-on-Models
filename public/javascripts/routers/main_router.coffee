namespace "routers"

class tt.routers.MainRouter extends Backbone.Router
  routes:
    "/articles/:id":  "article"
    "*page":          "index" # catch all


  initialize: ->
    console.log "da isser"
    # nothing...


  index: ->
    console.log "called!"


  article: (id) ->
    console.log(id)