require 'sugar'
startAsking = require './q-and-a.coffee'
particles = require './lib/particles.coffee'

coinFlip = -> !!Math.round(Math.random())

toBe = { i: 'am', you: 'are', it: 'is' }

englishConjugate = (subject, verb) -> verb[subject.toLowerCase()] or verb.it

makeEnglish = (sentence) ->
  subject = sentence.subject.english
  result = [subject]
  if sentence.verb?
    verb = englishConjugate(sentence.subject.english, sentence.verb.english)
    object = sentence.object?.english
    result.push verb
    result.push object.pluralize() if object
  else
    verb = englishConjugate(subject, toBe)
    adjective = sentence.adjective.english
    result.push verb
    result.push adjective
  return result.join(' ') + '.'

makeKorean = (sentence) ->
  subject = sentence.subject.korean
  subjectParticle = particles.subject(subject)
  result = [subject + subjectParticle]
  if sentence.verb?
    if sentence.object?
      object = sentence.object.korean
      objectParticle = particles.object(object)
      result.push(object + objectParticle)
    verb = sentence.verb.korean
    result.push verb
  else
    adjective = sentence.adjective.korean
    result.push adjective
  return result.join(' ') + '.'

$(document).ready ->

  jsonData = $.parseJSON($('#sentence-data').html())
  subjects = jsonData.subjects
  objects = jsonData.objects
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
        sentence.object = objects.sample() if sentence.verb.allowsObjects
      else
        sentence.adjective = adjectives.sample()

      answerLanguage = options.answerLanguage
      if options.questionLanguage is 'korean'
        return makeKorean sentence
      else
        return makeEnglish sentence

    check: (yourAnswer) ->
      yourAnswer = yourAnswer.compact().toLowerCase()
      return false

    rightAnswer: ->
      if answerLanguage is 'korean'
        makeKorean sentence
      else
        makeEnglish sentence
