_ = require 'lodash'
{get,post} = require '../services/rest-client'
socket = require '../services/socket-client'
{endpoints} = require '../config/server'
throttledRequest = requrie '../services/throttled-request'
htmlToText = require 'html-to-text'

textFetchersDir = path.resolve(__dirname__, '../text-fetchers')
textFetchers = (require(path.resolve(textFetchersDir,file)) for file in fs.readdirSync(textFetchersDir).sort() when !/^\./.test file and fs.lstatSync(file).isFile())

defaultTextFetcher =
  fetch: (url, cb) ->
    throttledRequest url, (err, body) ->
      return cb err if err?
      htmlToText body, cb

module.exports = class Article extends BaseModel
  @endpoints =
    collection: (feedId) -> endpoints.articles(feedId)
    model: (feedId, id) -> endpoints.article(feedId, id)

  Object.setProperties @prototype,
    textFetcher:
      get: ->
        return @_textFetcher if @_textFetcher
        for textFetcher in textFetchers when textFetcher.handles @url
          return @_textFetcher = textFetcher
        return defaultTextFetcher

  saveText: (cb) ->
    @textFetcher.fetch @url, (err, text) =>
      return cb err if err?
      client.post @constructor.endpoints.model(@feedId,@_id),
        text: text,
        cb
