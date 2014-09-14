_ = require 'lodash'
{get,post} = require '../services/rest-client'
socket = require '../services/socket-client'
{endpoints} = require '../config/server'
path = require 'path'
fs = require 'fs'
request = require 'request'
Article = require './article'
BaseModel = require './base'
debug = require('debug')('updater')
async = require 'async'

feedParsersDir = path.resolve(__dirname, '../feed-parsers')
parsers = (require(file) for file in fs.readdirSync(feedParsersDir).sort() when !/^\./.test file and fs.lstatSync(file = path.resolve(feedParsersDir,file)).isFile())

getParser = (url, resp, body) ->
  for parser in parsers when parser.handles url, resp.headers, body
    return parser

module.exports = class Feed extends BaseModel
  @endpoints =
    collection: endpoints.feeds
    model: endpoints.feed

  updateArticles: (cb) ->
    debug "Updating #{this}"

    request @url, (err, resp, body) =>
      return cb err if err?
      return cb new Error "No parser found for #{@}" unless parser = getParser @url, resp, body

      parser.parse @url, resp.headers, body, (err, articleJSONs) =>
        return cb err if err?

        Article.create {feedId: @_id}, articleJSONs, (err, articles) =>
          return cb err if err?

          if articles.length
            tasks = articles.map (article) ->
              (done) -> article.saveText -> done

            debug "Saving #{articles.length} articles for #{this}"

            async.parallel tasks, (err) ->
              feed.lastUpdated = new Date()
              feed.save()

