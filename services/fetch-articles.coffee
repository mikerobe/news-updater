path = require 'path'
fs = require 'fs'
request = require 'request'

module.exports = (feed, cb) ->
  request feed.url, (err, resp, body) ->
    return cb err if err?

  feedParsersDir = path.resolve(__dirname__, '../feed-parsers')
  for parser in parsers = (require(path.resolve(feedParsersDir,file)) for file in fs.readdirSync(feedParsers) when !/^\./.test file and fs.lstatSync(file).isFile())
    if parser.handles feed.url, resp.headers, body
      return parser.parse feed.url, resp.headers, body, cb

  cb new Error('no handler found')