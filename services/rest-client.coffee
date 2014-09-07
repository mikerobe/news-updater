Client = require 'rest-client'
serverConfig = require '../config/server'
url = require 'url'
_ = require 'lodash'

client = new Client url.resolve(serverConfig.href, 'api')

module.exports =
  client: client

  get: (endpoint, options, cb) ->
    [options, cb] = [{}, options] if typeof options is 'function'
    client.get _.defaults options,
      url: endpoint,
      success: (resp) -> cb? null, resp
      error: (resp) -> cb? resp

  post: (endpoint, params, options, cb) ->
    [options, cb] = [{}, options] if typeof options is 'function'
    client.post _.defaults options||{},
      url: endpoint,
      params: params
      success: (resp) -> cb? null, resp
      error: (resp) -> cb? resp
