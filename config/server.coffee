url = require 'url'
_ = require 'lodash'

endpoints =
  feeds: -> '/api/feeds'
  feed: (args) -> "#{endpoints.feeds()}/#{args._id}"
  articles: (args) -> "#{endpoints.feed({_id: args.feedId})}/articles"
  article: (args) -> "#{endpoints.articles(args)}/#{args._id}"
  articleText: (args) -> "#{endpoints.article(args)}/text"

config =
  endpoints: endpoints

configs =
  development: _.defaults
    port: process.env.PORT || 8080
    hostname: 'localhost'
    config

  production: _.defaults
    port: process.env.PORT || 80
    hostname: 'localhost'
    config

Object.defineProperties module.exports = config = configs[process.env.NODE_ENV?.toLowerCase() || 'production'],
  href:
    get: ->
      url.format _.defaults config, protocol: 'http'
