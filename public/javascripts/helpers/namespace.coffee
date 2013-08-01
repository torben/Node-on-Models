mainNamespace = 'tt'

window[mainNamespace] = {}

namespace = (name) ->
  unless window[mainNamespace][name]?
    window[mainNamespace][name] = {}