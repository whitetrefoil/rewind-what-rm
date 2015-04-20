db = require('../db')

sessionSchema =
  _updated:
    type: Date
    default: Date.now
  token: String


Sessions = db.model 'Sessions', sessionSchema

module.exports = Sessions
