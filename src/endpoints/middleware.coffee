restify = require('restify')
sessions = require('client-sessions')
uuid4 = require('uuid')
app = require('../app')
db = require('../db')
helpers = require('./helpers')
Users = db.model('Users')


# Session / Cookie
app.use sessions
  cookieName: 'sn'
  secret: uuid4()
  duration: 7 * 24 * 60 * 60 * 1000
  activeDuration: 7 * 24 * 60 * 60 * 1000


app.use (req, res, next) ->
  res.charSet('utf-8')
  next()
