io = require 'socket.io-client'
serverConfig = require '../config/server'
{EventEmitter} = require 'events'

socket = io serverConfig.href

module.exports = emitter = new EventEmitter

emitter.on = (endpoint, fn) ->
  unless @listeners(endpoint).length
    socket.emit 'subscribe', endpoint
    socket.on endpoint, emitter.emit.bind(emitter, endpoint)
  EventEmitter.prototype.on.apply(this, arguments)

emitter.off = (endpoint, fn) ->
  ret = EventEmitter.prototype.off.apply(this, arguments)
  unless @listeners(endpoint).length
    socket.emit 'unsubscribe', endpoint
  ret
