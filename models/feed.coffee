_ = require 'lodash'
{get,post} = require '../services/rest-client'
socket = require '../services/socket-client'
{endpoints} = require '../config/server'
path = require 'path'
fs = require 'fs'
request = require 'request'
Article = require './article'

feedParsersDir = path.resolve(__dirname__, '../feed-parsers')
parsers = (require(path.resolve(feedParsersDir,file)) for file in fs.readdirSync(feedParsersDir).sort() when !/^\./.test file and fs.lstatSync(file).isFile())

module.exports = class Feed extends BaseModel
  @endpoints =
    collection: -> endpoints.feeds
    model: (id) -> endpoints.feed id

  Object.setProperties @prototype,
    parser:
      get: ->
        return @_parser if @_parser
        for parser in parsers when parser.handles @url, resp.headers, body
          return @_parser = parser

  updateArticles: (cb) ->
    request @url, (err, resp, body) =>
      return cb err if err?
      return cb new Error 'No parser found' unless parser = @parser

      parser.parse @url, resp.headers, body, (err, articleJSONs) =>
        return cb err if err?

        Article.create @_id, articleJSONs, (err, articles) ->
          return cb err if err?

          tasks = articles.map (article) ->
            (done) -> article.saveText -> done

          async.parallel tasks, (err) ->
            feed.lastUpdated = new Date()
            feed.save()

