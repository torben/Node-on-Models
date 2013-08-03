namespace 'runtime'

$ ->
  checkScrollPosition = ->
    if window.pageYOffset <= 0
      $("#nav-begin-line").show()
      $(".nav").removeClass("shadow")
    else
      $("#nav-begin-line").hide()
      $(".nav").addClass("shadow")

  checkScrollPosition()

  $(window).on "scroll", (e) -> checkScrollPosition()

  tt.runtime.router = new tt.routers.MainRouter
  Backbone.history.start pushState: true

  $(document).on "click", "a", (e) ->
    return true if $(e.currentTarget).attr("rel") != "backbone"

    $.scrollTo(0)
    tt.runtime.router.navigate($(e.currentTarget).attr("href"), true)
    e.preventDefault()