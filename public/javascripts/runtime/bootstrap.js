// Generated by CoffeeScript 1.6.3
namespace('runtime');

$(function() {
  var checkScrollPosition;
  checkScrollPosition = function() {
    if (window.pageYOffset <= 0) {
      $("#nav-begin-line").show();
      return $(".nav").removeClass("shadow");
    } else {
      $("#nav-begin-line").hide();
      return $(".nav").addClass("shadow");
    }
  };
  checkScrollPosition();
  $(window).on("scroll", function(e) {
    return checkScrollPosition();
  });
  tt.runtime.router = new tt.routers.MainRouter;
  Backbone.history.start({
    pushState: true
  });
  return $(document).on("click", "a", function(e) {
    var offset, rel;
    rel = $(e.currentTarget).attr("rel");
    if (rel == null) {
      return;
    }
    if (rel === "backbone") {
      $.scrollTo(0, 100, function() {
        return tt.runtime.router.navigate($(e.currentTarget).attr("href"), true);
      });
      return e.preventDefault();
    } else if (rel.startsWith('scrollto:')) {
      offset = $(rel.split(":")[1]).offset();
      if (offset != null) {
        $.scrollTo(offset.top - $(".nav").height() - 10);
        return e.preventDefault();
      }
    }
  });
});
