_ = require('lodash')
app = require('../app')
db = require('../db')
restify = require('restify')
Users = db.model('Users')
Accounts = db.model('Accounts')
Sessions = db.model('Sessions')
helpers = require('./helpers')
encryption = require('../utils/encryption')


# GET users - get users list, require auth
app.get 'users'
, helpers.checkAuth
, (req, res, next) ->
  Users.find().lean().exec (err, users) ->
    if err?
      next(new restify.InternalServerError())
    else
      res.header('Last-Modified', _.max(users, '_updated')._updated)
      res._will = { items: users }
      next()
, restify.conditionalRequest()
, (req, res) ->
  res.json res._will


# GET users - get user by id, require auth
# TODO: Auth
app.get 'users/:id'
, helpers.checkAuth
, (req, res, next) ->
  Users.findById(req.params.id).lean().exec (err, user) ->
    if err?
      next(new restify.BadRequestError())
    else if not user?
      next(new restify.NotFoundError())
    else
      res.header('Last-Modified', user._updated)
      res._will = user
      next()
, restify.conditionalRequest()
, (req, res) ->
  res.json res._will


# POST users - create user, sign-in
app.post 'users', (req, res, next) ->
  #decrypted = encryption.decrypt(req.body, true)
  decrypted = req.body
  if _.isEmpty(decrypted.name) or _.isEmpty(decrypted.pass)
    return next(new restify.BadRequestError())

  Users.findOne({ name: decrypted.name }).lean().exec (err, existing) ->
    if existing?
      return next(new restify.ConflictError())
    else
      newUser =
        name: decrypted.name
        bio: decrypted.bio
      Users.create newUser, (err, user) ->
        if err? then return next(err)
        encryption.cryptPassword decrypted.pass, (err, salted) ->
          if err? then return next(err)
          Accounts.findByIdAndUpdate user.id,
            id: user.id
            token: salted
          ,
            upsert: true
          , (err, acc) ->
            if err? then return next(err)
            res.json 201, user.toJSON()


# PUT users - modify user information, require auth
app.put 'users/:id'
, helpers.checkAuth
, helpers.checkIfUnmodifiedSince
, (req, res, next) ->
  id = req.params.id
  Users.findById(id).exec (err, user) ->
    if err?
      next(new restify.InternalServerError())
    else if not user?
      next(new restify.NotFoundError())
    else
      res.header 'Last-Modified', user._updated
      res._will = user
      next()
, restify.conditionalRequest()
, (req, res, next) ->
  try
    res._will.set(req.body)
    res._will.set('_updated', Date.now())
  catch e
    return next(new restify.BadRequestError())
  res._will.save (err, user) ->
    if err?
      next(new restify.InternalServerError(err))
    else
      res.setHeader('Last-Modified', user._updated.toGMTString())
      res.json(200, user)


# DELETE users - deactivate a user, require auth
# TODO: This endpoint is for development only, now it will remove the user instead of deactivate it.
# TODO: Clean the related account and session
app.del 'users/:id'
, helpers.checkAuth
, helpers.checkIfUnmodifiedSince
, (req, res, next) ->
  id = req.params.id
  Users.findById(id).exec (err, user) ->
    if err?
      next(new restify.InternalServerError())
    else if not user?
      next(new restify.NotFoundError())
    else
      res.header 'Last-Modified', user._updated
      res._will = user
      next()
, restify.conditionalRequest()
, (req, res, next) ->
  res._will.remove (err, deleted) ->
    if err?
      next(new restify.InternalServerError())
    else
      res.status(204)
      res.end()


module.exports = app
