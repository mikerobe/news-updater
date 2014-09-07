_ = require 'lodash'
{get,post} = require '../services/rest-client'
socket = require '../services/socket-client'
{endpoints} = require '../config/server'

module.exports = class BaseModel
  Object.setProperties @prototype,
    endpoint:
      get: ->
        @constructor.endpoints.model this._id

  @subscribe = (args..., onUpdate) ->
    socket.on @endoints.collection(args...), onUpdate

  @findAll = (args..., cb) ->
    get @endpoints.collection(args...), cb

  @create: (args..., documents, cb) ->
    client.post @endpoints.collection(args...),
      (if _.isArray(documents) then {documents: documents} else documents),
      (err, reply) ->
        return cb err if err?
        if reply.ids
          for id, i in reply.ids
            if id
              documents[i]._id = id
            else
              documents[i] = null
          _.filter documents
        else
          documents._id = reply.id
          documents

  constructor: (attributes) ->
    _.extend this, attributes

  save: (cb) ->
    post @endpoint, this, cb

  