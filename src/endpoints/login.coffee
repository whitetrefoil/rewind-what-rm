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
  # TODO: Dev code
  #decrypted = encryption.decrypt(req.body)
  decrypted = req.body
  splitterIndex = decrypted.search(':')
  if splitterIndex < 0 then return next(new restify.BadRequestError())
  username = decrypted.substr(0, splitterIndex)
  password = decrypted.substr(splitterIndex + 1)
  Users.findOne({ name: username }).exec (err, user) ->
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


# GET sign-in = get the RSA public key for setting password
# TODO
#app.get '/sign-in'
#, (req, res, next) ->
#  res.json(encryption.publicKey)


# POST accounts = set password, only allowed for inactive users, require a temp token
# TODO
#app.post '/accounts'
#, (req, res, next) ->
#  try
#    # TODO: Dev code
#    #decrypted = encryption.decrypt(req.body)
#    decrypted = req.body
#    splitterIndex = decrypted.search(':')
#    if splitterIndex < 0 then return next(new restify.BadRequestError())
#    username = decrypted.substr(0, splitterIndex)
#    password = decrypted.substr(splitterIndex + 1)
#  catch e
#    return next(new restify.BadRequestError())
#  Users.findOne({ name: username }).exec (err, user) ->
#    if err?
#      return next(new restify.InternalServerError(err))
#    else if not user?
#      return next(new restify.NotFoundError())
#    else
#      id = user.id
#      Accounts.findById(id).exec (err, account) ->
#        if err?
#          return next(new restify.InternalServerError(err))
#        else if account?
#          return next(new restify.ConflictError())
#        else
#          encryption.cryptPassword password, (err, salted) ->
#            if err? then return next(new restify.InternalServerError(err))
#            console.log(id)
#            Accounts.create
#              _id: id
#              token: salted
#            , (err, account) ->
#              if err?
#                return next(new restify.InternalServerError(err))
#              else
#                res.json(201, _.omit(account.toJSON(), 'token'))


# PUT accounts = change password, require auth
# TODO
app.put '/accounts'
, (req, res, next) ->
  next(new restify.NotImplementedError())


module.exports = app
