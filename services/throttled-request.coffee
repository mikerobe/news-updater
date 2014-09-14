url = require 'url'
request = require 'request'
requestConfig = require '../config/request'
_ = require 'lodash'

callTimes = {}

fetch = (url, cb) ->
  request _.defaults(url: url, requestConfig), cb

module.exports = (href, millis, cb) ->
  [cb, millis] = [millis, 5000] unless cb?
  
  {hostname} = url.parse href
  now = Date.now()

  lastCall = callTimes[hostname] || 0
  if 0 < timeout = (callTimes[hostname] = Math.max(lastCall + millis, now)) - now
    setTimeout (-> fetch href, cb), timeout
  else
    fetch href, cb

  return
