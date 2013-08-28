namespace "views"

class tt.views.FooterView extends tt.views.MainView
  template: _.template($('#footer_template').html())
  className: 'row'

  render: ->
    @$el.html @template(mailLink: "#{tt.config.mailbox}@#{tt.config.mailServer}", protocol: 'mailto:')

    @