unless String::startsWith?
  String::startsWith = (str) ->
    @indexOf(str) == 0


unless String::endsWith?
  String::endsWith = (str) ->
    @slice(-str.length) == str