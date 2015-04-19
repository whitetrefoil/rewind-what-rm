app = require('./app')
db = require('./db')


models =
  users: require('./models/users')


endpoints =
  users: require('./endpoints/users')


conn = db.connection

conn.on 'error', ->
  console.error 'Connection Failed!'

conn.on 'open', ->
  app.listen 8080, ->
    console.log '%s listening at %s', app.name, app.url
