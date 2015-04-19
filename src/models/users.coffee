db = require('../db')

userSchema =
  _etag:
    type: String
    required: true
  name:
    type: String
    required: true
  bio: String

Users = db.model 'Users', userSchema

module.exports = Users
