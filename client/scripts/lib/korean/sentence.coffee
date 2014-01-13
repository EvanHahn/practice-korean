require 'sugar'
particles = require './particles.coffee'
add = particles.add

PUNCTUATION_REGEXP = /[!-\/:-@]/g

PUNCTUATION =
	default: '.'
	question: '?'
	exclamation: '!'

build = (sentence) ->

  result = []

  if sentence.location?
    location = sentence.location.korean
    result.push add.activeLocation(location)

  subject = sentence.subject.korean
  result.push add.subject(subject)

  if sentence.verb?

    if sentence.object?
      object = sentence.object.korean
      result.push add.object(object)

    verb = sentence.verb.korean
    result.push verb

  else
    adjective = sentence.adjective.korean
    result.push adjective

  if sentence.question
    punctuation = PUNCTUATION.question
  else if sentence.exclamation
    punctuation = PUNCTUATION.exclamation
  else
    punctuation = PUNCTUATION.default

  return result.join(' ') + punctuation

check = (answer, sentence) ->

  result = yes
  expectedLength = 2

  words = answer.replace(PUNCTUATION_REGEXP, '').words()

  lastWord = words.last()
  if sentence.verb?
    result = no if lastWord isnt sentence.verb.korean
  else
    result = no if lastWord isnt sentence.adjective.korean

  result = no if words.indexOf(add.subject(sentence.subject.korean)) is -1

  if sentence.location?
    expectedLength += 1
    result = no if words.indexOf(add.activeLocation(sentence.location.korean)) is -1

  if sentence.object?
    expectedLength += 1
    result = no if words.indexOf(add.object(sentence.object.korean)) is -1

  if sentence.question
    result = no if answer.last() isnt '?'
  else
    result = no if answer.last() is '?'

  if sentence.exclamation
    result = no if answer.last() isnt '!'

  result = no if words.length isnt expectedLength

  return result

module.exports = { build, check }
