# this code is mostly stolen from:
# https://npmjs.org/package/eulrlega
# but it's licensed nicely so that's OK

eulrlega = (word) ->

  last = word.charAt(word.length - 1).charCodeAt 0
  return true if last < 0xac00
  last -= 0xac00
  jong = (last % 28) + 0x11a7
  if jong is 4519
    return false
  else
    return true

chooseBetween = (a, b, word) ->
  if eulrlega(word) then a else b

addTo = (fn) -> (word) -> word + fn(word)

object = (word) -> chooseBetween '을', '를', word
topic = (word) -> chooseBetween '은', '는', word
subject = (word) -> chooseBetween '이', '가', word

add =
  object: (word) -> word + object(word)
  topic: (word) -> word + topic(word)
  subject: (word) ->
    particle = subject word
    if word is '저'
      return '제' + particle
    else
      return word + particle
  activeLocation: (word) -> word + '에서'

module.exports = { object, topic, subject, add }
