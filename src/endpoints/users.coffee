_ = require('lodash')
app = require('../app')
db = require('../db')
restify = require('restify')
Users = db.model('Users')


app.get 'users', (req, res, next) ->
  Users.find().lean().exec (err, users) ->
    if err?
      next(new restify.InternalServerError())
    else
      res.header('Last-Modified', _.max(users, '_updated')['_updated'])
      res['_willResponse'] = { items: users }
      next()
, restify.conditionalRequest()
, (req, res) ->
  res.json res['_willResponse']


app.post 'users', (req, res, next) ->
  Users.findOne({ name: req.body.name }).lean().exec (err, existing) ->
    if existing?
      res.json 200, existing
      res.end()
    else
      newUser =
        name: req.body.name
        bio: req.body.bio
      Users.create(newUser).lean().exec (err, user) ->
        res.json 201, user
        res.end()


app.get 'test'
, (req, res, next) ->
  res.header 'ETag', 'asdf123'
  next()
, restify.conditionalRequest()
, (req, res, next) ->
  console.log 'asdf'
  res.json []
