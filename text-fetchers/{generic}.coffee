throttledRequest = require '../services/throttled-request'
htmlToTxt = require '../services/html-to-txt'

module.exports =
  handles: (url) -> true
  fetch: (url, cb) ->
    throttledRequest url, (err, resp, body) ->
      return cb err if err?
      htmlToTxt body, cb
