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
, helpers.checkAuth
, (req, res, next) ->
  helpers.generateToken req.user.id, (err, session) ->
    if err?
      return next(err)
    else
      return res.json session


# POST login = login, send valid username + password in body, get a new token
app.post '/login'
, (req, res, next) ->
  decrypted = encryption.decrypt(req.body, true)
  if not decrypted?
    return next(new restify.BadRequestError('Error when decryption.'))
  username = decrypted.name
  password = decrypted.pass
  Users.findOne({ name: username }).exec (err, user) ->
    if not user?
      return next(new restify.UnauthorizedError())
    else
      Accounts.findById(user.id).exec (err, acc) ->
        encryption.checkPassword password, acc.token, (err, isMatch) ->
          if isMatch
            helpers.generateToken acc.id, (err, session) ->
              if err?
                return next(err)
              else
                return res.json session
          else
            return next(new restify.UnauthorizedError())


# PUT accounts = change password, require auth
# TODO
app.put '/accounts'
, (req, res, next) ->
  next(new restify.NotImplementedError())


# GET key = get a public key for sign-in and log-in
app.get '/key'
, (req, res, next) ->
  res.json encryption.publicKey


module.exports = app
