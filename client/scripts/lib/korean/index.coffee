sentence = require './sentence.coffee'
particles = require './particles.coffee'

module.exports =

  sentence: sentence

  object: particles.object
  subject: particles.subject
  topic: particles.topic
  add: particles.add