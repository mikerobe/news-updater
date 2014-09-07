_ = require 'lodash'
{get,post} = require '../services/rest-client'
socket = require '../services/socket-client'
{endpoints} = require '../config/server'

module.exports = class Feed extends BaseModel
  @endpoints =
    collection: -> endpoints.feeds
    model: (id) -> endpoints.feed id
