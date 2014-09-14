{spawn} = require('child_process')

cmd = "/usr/local/bin/elinks"
args = "-no-home 1 -no-references -default-mime-type text/html -no-numbering -dump-width 43 -dump 1 -dump-charset utf-8".split(' ')

module.exports = (body, cb) ->
  reply = ''

  handleError = (err) ->
    cb? err || new Error
    cb = null
    return

  handleData = (data) ->
    reply += data if data

  child = spawn cmd, args
  child.on 'error', handleError
  child.stdout.on 'error', handleError
  child.stdin.end(body)

  child.stdout.on 'data', handleData
  child.stdout.on 'end', (data) ->
    handleData data
    cb? null, reply
    return

  return
