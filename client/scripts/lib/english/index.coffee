require 'sugar'

PUNCTUATION_REGEXP = /[!-\/:-@]/g
PUNCTUATION =
	default: '.'
	question: '?'
	exclamation: '!'

ENGLISH_ARTICLES = ['the', 'a', 'an']

TO_BE_VERB = { i: 'am', you: 'are', it: 'is' }
QUESTION_DO = { i: 'do', you: 'do', it: 'does' }

capitalizeFirstLetter = (str) -> str.charAt(0).toUpperCase() + str.slice(1)

conjugate = (subject, verb = TO_BE_VERB) ->
	verb[subject.toLowerCase()] or verb.it

build = (sentence) ->

  result = []

  if sentence.question
    if sentence.verb?
      result.push conjugate(sentence.subject.english, QUESTION_DO)
    else
      result.push conjugate(sentence.subject.english, TO_BE_VERB)

  subject = sentence.subject.english
  result.push subject

  if sentence.verb?

    if sentence.question
      verb = conjugate('I', sentence.verb.english)
    else
      verb = conjugate(sentence.subject.english, sentence.verb.english)
    object = sentence.object?.english
    result.push verb
    result.push object if object

  else

    unless sentence.question
      verb = conjugate(subject, TO_BE_VERB)
      result.push verb

    adjective = sentence.adjective.english
    result.push adjective

  if sentence.question
    punctuation = PUNCTUATION.question
  else if sentence.exclamation
    punctuation = PUNCTUATION.exclamation
  else
    punctuation = PUNCTUATION.default

  return capitalizeFirstLetter(result.join(' ') + punctuation)

check = (answer, sentence) ->

  result = yes
  expectedLength = 3

  answer = answer.toLowerCase()
  answer = answer.replace(/i'm/g, 'i am')
  answer = answer.replace(/you're/g, 'you are')
  answer = answer.replace(/'s/g, ' is')

  isStatementStyle = !!sentence.question

  words = answer.replace(PUNCTUATION_REGEXP, ' ').words()
  firstWord = words.first()

  expectedSubject = sentence.subject.english.toLowerCase()

  if sentence.question

    result = no if answer.last() isnt '?'

    if sentence.verb?
      expectedVerb = conjugate 'I', sentence.verb.english
      questionVerb = conjugate(expectedSubject, QUESTION_DO)
      if firstWord is questionVerb
        words = words.slice 1
        firstWord = words.first()
      result = no if firstWord isnt expectedSubject
      result = no if words[1] isnt expectedVerb
      if sentence.object?
        expectedObject = sentence.object.english.toLowerCase()
        result = no if words[3] isnt expectedObject

    else
      questionVerb = conjugate(expectedSubject, TO_BE_VERB)
      firstTwo = words.first 2
      result = no if firstTwo.indexOf(expectedSubject) is -1
      result = no if firstTwo.indexOf(questionVerb) is -1
      result = no if words[2] isnt sentence.adjective.english

  else

    result = no if answer.last() is '?'
    if sentence.exclamation
      result = no if answer.last() isnt '!'

    if sentence.verb?
      expectedVerb = conjugate sentence.subject.english, sentence.verb.english
      if sentence.object?
        expectedObject = sentence.object.english
        result = no if words[2] isnt expectedObject

    else
      expectedVerb = conjugate sentence.subject.english, TO_BE_VERB
      expectedAdjective = sentence.adjective.english
      result = no if words[2] isnt expectedAdjective

    result = no if words[1] isnt expectedVerb

  return result

module.exports =
  sentence: { build, check }
