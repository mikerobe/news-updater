url = require 'url'

module.exports = (href, cb) ->
  {hostname} = url.parse href
  
