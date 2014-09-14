serverConfig = require '../config/server'
request = require 'request'
url = require 'url'
_ = require 'lodash'
debug = require('debug')('updater')

handleJsonReply = (endpoint, cb) ->
  (err, resp, body) ->
    if err?
      debug "Error getting from #{endpoint}"
      return cb err

    unless 200 <= resp.statusCode < 300
      return cb new Error(body?.message || body)

    try
      unless _.isObject body
        body = JSON.parse(body)
    catch _error
      return cb new Error "Got unexpected non-JSON response from #{endpoint}"

    cb null, body


resolveEndpoint = (endpoint) ->
  url.resolve(serverConfig.href, endpoint)

module.exports =
  get: (endpoint, cb) ->
    request
      url: resolveEndpoint(endpoint)
      handleJsonReply(endpoint, cb)

  post: (endpoint, params, cb) ->
    request
      method: 'POST'
      url: resolveEndpoint(endpoint)
      json: params
      handleJsonReply(endpoint, cb)


