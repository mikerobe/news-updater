Feed = require './models/feed'
debug = require('debug')('updater')

update = (feed) ->
  feed.updateArticles (err) ->
    if err?
      debug "Error updating #{feed}:", err
    setTimeout update.bind(feed), feed.refreshMillis
    return
  return

debugger

Feed.watch (newFeeds) ->
  update feed for feed in newFeeds
  return
