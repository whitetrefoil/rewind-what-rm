restify = require('restify')
uuid4 = require('uuid')
db = require('../db')
Sessions = db.model('Sessions')
config = require('../config.json')


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


  generateToken: (id, cb) ->
    # #findByIdAndUpdate will not send the newly created if upsert
    Sessions.findById id, (err, session) ->
      if err?
        return cb?(err)
      else if session?
        session.set('token', uuid4())
        session.set('_updated', Date.now())
        session.save (err, updated) ->
          if err?
            return cb?(err)
          else
            return cb?(null, updated)
      else
        Sessions.create
          _id: id
          token: uuid4()
        , (err, updated) ->
            if err?
              return cb?(err)
            else
              return cb?(null, updated)


  checkToken: (id, token, cb) ->
    Sessions.findById id, (err, session) ->
      expire = config.token_expire_days * 24 * 60 * 60 * 1000
      cb?(null, (session.token is token) and (session._updated.valueOf() + expire > Date.now))


module.exports = helpers
