_ = require('lodash')
app = require('../app')
db = require('../db')
restify = require('restify')
Users = db.model('Users')
Posts = db.model('Posts')
helpers = require('./helpers')


# GET posts - list all posts


# POST posts - create a new post
app.post '/posts'
, helpers.checkAuth
, (req, res, next) ->
  Posts.create
    author: req.sn.user._id
    content: req.body.content
  , (err, post) ->
      if err?
        console.warn(err) # TODO
        next(new restify.BadRequestError())
      else
        res.json post
