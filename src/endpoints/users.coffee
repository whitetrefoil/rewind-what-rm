_ = require('lodash')
app = require('../app')
db = require('../db')
restify = require('restify')
Users = db.model('Users')
helpers = require('./helpers')


# GET users - get users list, require auth
# TODO: Auth
app.get 'users', (req, res, next) ->
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
app.get 'users/:id', (req, res, next) ->
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


# POST users - create user
# TODO: handle duplicated users
# TODO: handle inactive users
app.post 'users', (req, res, next) ->
  Users.findOne({ name: req.body.name }).lean().exec (err, existing) ->
    if existing?
      res.json 200, existing
    else
      newUser =
        name: req.body.name
        bio: req.body.bio
      Users.create newUser, (err, user) ->
        res.json 201, user.toJSON()


# PUT users - modify user information, require auth
# TODO: require auth
app.put 'users/:id', helpers.checkIfUnmodifiedSince
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
# TODO: require auth
# TODO: This endpoint is for development only, now it will remove the user instead of deactivate it.
# TODO: Clean the related account and session
app.del 'users/:id', helpers.checkIfUnmodifiedSince
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
