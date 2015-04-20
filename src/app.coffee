restify = require('restify')
app = restify.createServer()
app.use(restify.acceptParser(app.acceptable))
app.use(restify.authorizationParser())
app.use(restify.dateParser())
app.use(restify.queryParser())
app.use(restify.jsonp())
app.use(restify.gzipResponse())
app.use restify.bodyParser
  maxBodySize: 4194304
  mapParams: false
  mapFiles: false

app.use (req, res, next) ->
  res.charSet('utf-8')
  next()

#app.use(restify.conditionalRequest())

module.exports = app
