FeedList = require './services/feed-list'
fetchArticles = require './services/fetch-articles'
fetchArticleText = require './services/fetch-article-text'
async = require 'async'
_ = require 'lodash'

updateFeed = (feed) ->
  fetchArticles feed, (err, articles) ->
    return if err?

    Article.create feed._id, articles, (err, ids) ->
      return if err?

      for id, i in ids.ids
        if !id?
          articles[i] = null
        else
          articles[i]._id = id

      articles = _.filter(articles)
      tasks = articles.map (article) ->
        (cb) -> fetchArticleText article, cb

      async.parallel tasks, (err,  )

    feed.lastUpdated = new Date()
    feed.save()

feedList = new FeedList
feedList.watch (newFeeds) ->
  for feed in newFeeds
    setInterval updateFeed.bind(feed), feed.refreshMillis
