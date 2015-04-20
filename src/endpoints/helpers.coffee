restify = require('restify')


isValidGMTDateString = (dateStr) ->
  parsed = new Date(dateStr)
  !isNaN(parsed) and parsed.toGMTString() is dateStr


helpers =
  checkIfUnmodifiedSince: (req, res, next) ->
    since = req.headers['if-unmodified-since']
    if isValidGMTDateString(since)
      next()
    else
      next(new restify.PreconditionFailedError())


module.exports = helpers
