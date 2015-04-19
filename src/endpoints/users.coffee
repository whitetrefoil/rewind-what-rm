app = require('../app')
db = require('../db')
restify = require('restify')
Users = db.model('Users')

app.get 'users', (req, res, next) ->
  Users.find().lean().exec (err, users) ->
    if err?
      next(new restify.InternalServerError())
    else
      res.header 'Last-Modified', new Date()
      res.json
        items: users


app.post 'users', (req, res, next) ->
  console.log(req.body)
  res.end()


app.get 'test'
, (req, res, next) ->
  res.header 'ETag', 'asdf123'
  next()
, restify.conditionalRequest()
, (req, res, next) ->
  console.log 'asdf'
  res.json []
