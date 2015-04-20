_ = require('lodash')
app = require('../app')
db = require('../db')
restify = require('restify')
Users = db.model('Users')
Accounts = db.model('Accounts')
Sessions = db.model('Sessions')
helpers = require('./helpers')
encryption = require('../utils/encryption')


# GET login = refresh, send a valid token in header, get a new token and refresh the expire time
# TODO
app.get '/login'
, (req, res, next) ->
  next(new restify.NotImplementedError())


# POST login = login, send valid username + password in body, get a new token
# TODO
app.post '/login'
, (req, res, next) ->
  next(new restify.NotImplementedError())


# GET sign-in = get the RSA public key for setting password
# TODO
app.get '/sign-in'
, (req, res, next) ->
  res.json(encryption.publicKey)


# POST accounts = set password, only allowed for inactive users, require a temp token
# TODO
app.post '/accounts'
, (req, res, next) ->
  next(new restify.NotImplementedError())


# PUT accounts = change password, require auth
# TODO
app.put '/accounts'
, (req, res, next) ->
  next(new restify.NotImplementedError())


module.exports = app
