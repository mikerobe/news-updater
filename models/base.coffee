_ = require 'lodash'
{get,post} = require '../services/rest-client'
socket = require '../services/socket-client'
{endpoints} = require '../config/server'

module.exports = class BaseModel
  Object.defineProperties @prototype,
    endpoint:
      get: ->
        @constructor.endpoints.model this

  @subscribe = (args, onUpdate) ->
    [args,cb] = [{},args] unless cb
    socket.on @endpoints.collection(args), onUpdate

  @findAll = (args, cb) ->
    [args,cb] = [{},args] unless cb
    get @endpoints.collection(args), cb

  @watch: (args, update) ->
    [args,update] = [{},args] unless update

    seenIds = {}
    @subscribe args, (document) =>
      unless seenIds[document._id]
        seenIds[document._id] = 1
        update [new this document]
      return
    @findAll args, (err, documents) =>
      return if err? || !documents || !documents.length
      update documents.map (document) => new this document
      return
    return

  @create: (args, documents, cb) ->
    [args,documents,cb] = [{},args,documents] unless cb

    post @endpoints.collection(args),
      (if _.isArray(documents) then {documents: documents} else documents),
      (err, reply) =>
        return cb err if err?
        documents = if reply.ids
          for id, i in reply.ids
            if id
              documents[i]._id = id
            else
              documents[i] = null
          _.filter documents
        else
          documents._id = reply.id
          [documents]

        cb null, documents.map (document) => new this _.defaults(document,args)

  constructor: (attributes) ->
    _.extend this, attributes

  toString: ->
    "#{@constructor.name} [#{@title || @name || @_id}]"

  save: (cb) ->
    post @endpoint, this, cb

  