_ = require 'lodash'
{get,post} = require '../services/rest-client'
socket = require '../services/socket-client'
{endpoints} = require '../config/server'

module.exports = class Article extends BaseModel
  @endpoints =
    collection: (feedId) -> endpoints.articles(feedId)
    model: (feedId, id) -> endpoints.article(feedId, id)

  saveText: (text, cb) ->
    client.post @constructor.endpoints.model(@feedId,@_id),
      text: text,
      cb
