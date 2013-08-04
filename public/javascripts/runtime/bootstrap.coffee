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
    rel = $(e.currentTarget).attr("rel")
    return unless rel?

    if rel == "backbone"
      $.scrollTo(0)
      tt.runtime.router.navigate($(e.currentTarget).attr("href"), true)
      e.preventDefault()
    else if rel.startsWith('scrollto:')
      offset = $(rel.split(":")[1]).offset()
      if offset?
        $.scrollTo(offset.top - $(".nav").height() - 10)
        e.preventDefault()