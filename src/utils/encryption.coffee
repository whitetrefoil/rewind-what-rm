RSAKey = require('node-rsa')
bcrypt = require('bcrypt')


# TODO: using smaller key to speed-up development, replace after that
privateKey = new RSAKey({ b: 512 })
publicKey = privateKey.exportKey('public').replace(/\n/g, '').replace(/--[\w -]+--/g, '')

encryption =
  # RSA keys for sign in
  publicKey: publicKey

  decrypt: (encrypted, isJson = false) ->
    if isJson
      privateKey.decrypt(encrypted, 'json')
    else
      privateKey.decrypt(encrypted).toString('utf-8')


  cryptPassword: (pass, cb) ->
    bcrypt.hash pass, 10, (err, hash) ->
      if err?
        cb?(err)
      else
        cb?(null, hash)


  checkPassword: (pass, encrypted, cb) ->
    bcrypt.compare pass, encrypted, (err, isSame) ->
      if err?
        cb?(err)
      else
        cb?(null, isSame)


module.exports = encryption
