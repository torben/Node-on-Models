namespace 'views'

class tt.views.ArticleView extends tt.views.MainView
  template: _.template($('#article_template').html())
  className: 'content'

  initialize: (options) ->
    super(options)


  render: ->
    @$el.html(@template(@model.toJSON()))

    @