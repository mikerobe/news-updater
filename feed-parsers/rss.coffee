FeedParser = require 'feedparser'
request = require 'request'

module.exports =
  handles: (url, headers, body) ->
    /\bxml\b/i.test(headers['content-type'])

  parse: (url, headers, body, cb) ->
    feedparser = new FeedParser addmeta: false
    feedparser.end body
    feedparser.on 'error', (err) -> cb err
    feedparser.on 'readable', ->
      articles = while article = @read()
        article.url = article.origlink || article.link
        article
      cb null, articles

