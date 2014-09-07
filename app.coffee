FeedList = require './services/feed-list'

feedList = new FeedList
feedList.watch (newFeeds) ->
  for feed in newFeeds
    setInterval feed.updateArticles.bind(feed), feed.refreshMillis
  return
