restify = require('restify')
app = require('../app')
db = require('../db')
helpers = require('./helpers')
Users = db.model('Users')
Sessions = db.model('Sessions')


app.use (req, res, next) ->
  res.charSet('utf-8')
  next()


# Get User Info
app.use (req, res, next) ->
  token = req.headers['x-token']
  if token?
    helpers.checkToken token, (err, session) ->
      if not err? and session?.id?
        Users.findById session.id, (err, user) ->
          if not err? and user?
            req.user = user
            next()
          else
            next()
      else
        next()
  else
    next()
