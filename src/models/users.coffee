db = require('../db')

userSchema =
  name:
    type: String
    required: true
  bio: String

Users = db.model 'Users', userSchema

module.exports = Users
