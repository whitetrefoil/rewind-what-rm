db = require('../db')


userSchema =
  _created:
    type: Date
    default: Date.now
    set: -> @_created
  _updated:
    type: Date
    default: Date.now
  name:
    type: String
    required: true
    unique: true
    index: true
  bio: String


Users = db.model 'Users', userSchema


module.exports = Users
