url = require 'url'
_ = require 'lodash'

configs =
  development:
    port: 8080
    hostname: 'localhost'

  production:
    port: 80
    hostname: 'localhost'

configs.endpoints = endpoints =
  feeds: '/api/feeds'
  feed: (id) -> "#{endpoints.feeds}/#{id}"
  articles: (feedId) -> "#{endpoints.feed(feedId)}/articles"
  article: (feedId, articleId) -> "#{endpoints.articles(feedId)}/#{articleId}"
  articleText: (feedId, articleId) -> "#{endpoints.article(feedId,articleId)}/text"

Object.defineProperties module.exports = config = configs[process.env.NODE_ENV?.toLowerCase() || 'production'],
  href:
    get: ->
      url.format _.defaults config, protocol: 'http'
