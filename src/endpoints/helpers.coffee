restify = require('restify')
uuid4 = require('uuid')
db = require('../db')
config = require('../config.json')


isValidGMTDateString = (dateStr) ->
  parsed = new Date(dateStr)
  !isNaN(parsed) and parsed.toGMTString() is dateStr


helpers =
  checkAuth: (req, res, next) ->
    if req.sn?.user?
      next()
    else
      next(new restify.UnauthorizedError())


  checkIfUnmodifiedSince: (req, res, next) ->
    since = req.headers['if-unmodified-since']
    if isValidGMTDateString(since)
      next()
    else
      next(new restify.PreconditionFailedError())


module.exports = helpers
