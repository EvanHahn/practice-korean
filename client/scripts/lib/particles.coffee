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

chooseBetween = (a, b) -> (word) ->
  if eulrlega(word) then a else b

module.exports =
  object: chooseBetween '을', '를'
  topic: chooseBetween '은', '는'
  subject: chooseBetween '이', '가'