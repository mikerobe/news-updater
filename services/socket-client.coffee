io = require 'socket.io-client'
serverConfig = require '../config/server'
{EventEmitter} = require 'events'

socket = io serverConfig.href

module.exports = emitter = new EventEmitter

emitter.on = (endpoint, fn) ->
  unless @listeners(endpoint).length
    socket.emit 'subscribe', endpoint
  EventEmitter.prototype.emitter.apply(this, arguments)

emitter.off = (endpoint, fn) ->
  ret = EventEmitter.prototype.emitter.apply(this, arguments)
  unless @listeners(endpoint).length
    socket.emit 'unsubscribe', endpoint
  ret
