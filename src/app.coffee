restify = require('restify')
db = require('./db')
server = restify.createServer()
bodyParser = require('body-parser')

init = ->
  server.use(bodyParser.json())
  server.post 'users', (req, res, next) ->
    res.send(req.body)
    res.end()

  server.listen 8080, ->
    console.log '%s listening at %s', server.name, server.url


conn = db.connection

conn.on 'error', ->
  console.error 'Connection Failed!'

conn.on 'open', ->
  init()
