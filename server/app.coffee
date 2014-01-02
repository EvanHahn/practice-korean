express = require 'express'
path = require 'path'
fs = require 'fs'

app = express()

do -> # static middleware

  staticFrom = (directory) ->
    fullPath = path.resolve(__dirname, directory)
    return express.static(fullPath)

  app.use staticFrom '../client/public'
  app.use staticFrom '../tmp/serve'

module.exports = app
