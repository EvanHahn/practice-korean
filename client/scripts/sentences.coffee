require 'sugar'
startAsking = require './q-and-a.coffee'
english = require './lib/english/index.coffee'
korean = require './lib/korean/index.coffee'

coinFlip = (value = .5) -> Math.random() < value

$(document).ready ->

  jsonData = $.parseJSON($('#sentence-data').html())
  subjects = jsonData.subjects
  locations = jsonData.locations
  verbs = jsonData.verbs
  adjectives = jsonData.adjectives

  sentence = null
  answerLanguage = null

  startAsking

    languageSelect: true

    ask: (options) ->

      sentence = {}

      sentence.subject = subjects.sample()

      if coinFlip()
        sentence.verb = verbs.sample()
        if sentence.verb.objects? and coinFlip()
          sentence.object = sentence.verb.objects.sample()
        if coinFlip(.3)
          sentence.location = locations.sample()
      else
        sentence.adjective = adjectives.sample()


      if coinFlip(.25)
        sentence.question = yes

      answerLanguage = options.answerLanguage
      if options.questionLanguage is 'korean'
        return korean.sentence.build sentence
      else
        return english.sentence.build sentence

    check: (yourAnswer) ->
      return false if yourAnswer.isBlank()
      answer = yourAnswer.compact()
      if answerLanguage is 'korean'
        korean.sentence.check answer, sentence
      else
        english.sentence.check answer, sentence

    rightAnswer: ->
      if answerLanguage is 'korean'
        korean.sentence.build sentence
      else
        english.sentence.build sentence
