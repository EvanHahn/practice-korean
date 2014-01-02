ONES = [
  '', # nothing in the ones place
  '하나',
  '둘',
  '셋',
  '넷',
  '다섯',
  '여섯',
  '일곱',
  '여덟',
  '아홉'
]

TENS = [
  '', # nothing in the tens place
  '열',
  '스물',
  '서른',
  '마흔',
  '쉰',
  '예순',
  '일흔',
  '여든',
  '아흔'
]

getKorean = (n) ->
  tens = Math.floor(n / 10)
  ones = n - (tens * 10)
  if tens and ones
    return TENS[tens] + ' ' + ONES[ones]
  else
    return TENS[tens] + ONES[ones]

random = (min, max) ->
  size = max - min
  return Math.floor(Math.random() * size) + min

$(document).ready ->

  answer = null

  startAsking

    languageSelect: true

    ask: (options) ->

      number = random(1, 99)
      koreanNumber = getKorean number

      if options.questionLanguage is 'korean'
        question = koreanNumber
        answer = number
      else
        question = number
        answer = koreanNumber

      return question

    check: (yourAnswer) ->
      yourAnswer = yourAnswer.replace(/\s+/g, '')
      theAnswer = answer.replace(/\s+/g, '')
      return yourAnswer is theAnswer

    rightAnswer: -> answer
