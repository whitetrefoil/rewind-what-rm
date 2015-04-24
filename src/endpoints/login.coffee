_ = require('lodash')
app = require('../app')
db = require('../db')
restify = require('restify')
Users = db.model('Users')
Accounts = db.model('Accounts')
helpers = require('./helpers')
encryption = require('../utils/encryption')


# GET login = get current logged-in user
app.get '/login'
, helpers.checkAuth
, (req, res, next) ->
  res.json req.sn.user


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
            req.sn.user = user.toJSON()
            res.json(user)
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
