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


# TODO: Remove below debug code
app.on 'uncaughtException', (req, res, route, err) ->
  console.log('uncaughtException', err.stack)


module.exports = app
