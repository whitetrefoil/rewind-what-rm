db = require('../db')

userSchema =
  _updated:
    type: Date
    default: Date.now
  name:
    type: String
    required: true
    unique: true
  bio: String

Users = db.model 'Users', userSchema

module.exports = Users
