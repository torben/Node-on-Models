namespace "helpers"

tt.helpers.ScriptsLoader = do ->
  loadScripts: (scripts, withLoadingBar = false) ->
    $("#progress").hide() unless withLoadingBar
    maxPercent = scripts.length
    i = 1
    for script in scripts
      document.write('<script src="'+script+'"><\/script>')
      percent = i / maxPercent * 100 + 5

      document.write '<script>percent = '+percent+';$("#progress").width(percent+"%");</script>' if withLoadingBar
      i++

    document.write '<script>$("#progress").addClass("animated fadeOut")</script>' if withLoadingBar