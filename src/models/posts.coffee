db = require('../db')


postSchema =
  _created:
    type: Date
    default: Date.now
    set: -> @_created
  _updated:
    type: Date
    default: Date.now
  author:
    type: db.Schema.Types.ObjectId
    required: true
    index: true
  content:
    type: String
    default: ''
  replies: [
    author:
      type: db.Schema.Types.ObjectId
      required: true
      index: true
    content:
      type: String
      default: ''
  ]


Posts = db.model 'Posts', postSchema


module.exports = Posts
