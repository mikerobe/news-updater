_ = require 'lodash'
{get,post} = require '../services/rest-client'
socket = require '../services/socket-client'
{endpoints} = require '../config/server'
path = require 'path'
fs = require 'fs'
BaseModel = require './base'

textFetchersDir = path.resolve(__dirname, '../text-fetchers')
textFetchers = (require(file) for file in fs.readdirSync(textFetchersDir).sort() when !/^\./.test file and fs.lstatSync(file = path.resolve(textFetchersDir,file)).isFile())

getTextFetcher = (url) ->
  for textFetcher in textFetchers when textFetcher.handles @url
    return @_textFetcher = textFetcher

module.exports = class Article extends BaseModel
  @endpoints =
    collection: endpoints.articles
    model: endpoints.article
    text: endpoints.articleText

  saveText: (cb) ->
    return cb new Error "Couldn't find text fetcher for [#{@url}]" unless textFetcher = getTextFetcher @url
    textFetcher.fetch @url, (err, text) =>
      return cb err if err?
      post @constructor.endpoints.text(this),
        text: text,
        cb
