require 'sugar'
startAsking = require './q-and-a.coffee'
particles = require './lib/particles.coffee'

coinFlip = -> !!Math.round(Math.random())

ENGLISH_ARTICLES = ['the', 'a', 'an']
toBe = { i: 'am', you: 'are', it: 'is' }

englishConjugate = (subject, verb) -> verb[subject.toLowerCase()] or verb.it

makeEnglish = (sentence) ->
  subject = sentence.subject.english
  if subject is subject.capitalize()
    result = [subject.capitalize()]
  else
    result = ['The', subject]
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

checkEnglish = (sentence, answer) ->
  words = answer.words().exclude (word) ->
    ENGLISH_ARTICLES.indexOf(word.toLowerCase()) isnt -1
  subject = words.first()
  debugger
  return false if subject isnt sentence.subject.english.toLowerCase()
  if sentence.verb?
    rightVerb = englishConjugate(subject, sentence.verb.english)
    if sentence.object?
      rightObject = sentence.object.english
      pluralResult = do ->
        word = words[2]
        return true if word is rightObject
        return true if word.pluralize() is rightObject
        return true if word is rightObject.pluralize()
        return null
      return pluralResult if pluralResult?
      return false if words.length isnt 3
    else
      return false if words.length isnt 2
  else
    rightVerb = englishConjugate(sentence.subject.english, toBe)
    rightAdjective = sentence.adjective.english
    return false if words.length isnt 3
    return false if words[2] isnt rightAdjective
  return false if words[1] isnt rightVerb
  return true

checkKorean = (sentence, answer) ->
  words = answer.words()
  last = words.last()
  if sentence.verb?
    return false if last isnt sentence.verb.korean
    rightSubject = sentence.subject.korean + particles.subject(sentence.subject.korean)
    if sentence.object?
      firstTwo = words.first 2
      rightObject = sentence.object.korean + particles.object(sentence.object.korean)
      return false if firstTwo.indexOf(rightSubject) is -1
      return false if firstTwo.indexOf(rightObject) is -1
      return false if words.length isnt 3
    else
      return false if words.first() isnt rightSubject
      return false if words.length isnt 2
  else
    return false if last isnt sentence.adjective.korean
    return false if words.length isnt 2
  return true

$(document).ready ->

  jsonData = $.parseJSON($('#sentence-data').html())
  subjects = jsonData.subjects
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
      else
        sentence.adjective = adjectives.sample()

      answerLanguage = options.answerLanguage
      if options.questionLanguage is 'korean'
        return makeKorean sentence
      else
        return makeEnglish sentence

    check: (yourAnswer) ->
      return false if yourAnswer.isBlank()
      answer = yourAnswer.compact()
      punctuation = /[!-\/:-@]/g
      if answerLanguage is 'korean'
        answer = answer.replace(punctuation, '')
        checkKorean sentence, answer
      else
        answer = answer.toLowerCase()
        answer = answer.replace(/i'm/g, 'i am')
        answer = answer.replace(/'s/g, ' is')
        answer = answer.replace(punctuation, '')
        checkEnglish sentence, answer

    rightAnswer: ->
      if answerLanguage is 'korean'
        makeKorean sentence
      else
        makeEnglish sentence
