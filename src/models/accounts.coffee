db = require('../db')

accountSchema =
  _updated:
    type: Date
    default: Date.now
  token: String


Accounts = db.model 'Accounts', accountSchema

module.exports = Accounts
