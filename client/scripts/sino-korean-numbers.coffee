startAsking = require './q-and-a.coffee'

getKorean = (n) ->
  "TODO"

random = (min, max) ->
  size = max - min
  return Math.floor(Math.random() * size) + min

$(document).ready ->

  answer = null

  startAsking

    languageSelect: true
    sliders:
      'Minimum': { range: [0, 1e6], start: 0, step: 100 }
      'Maximum': { range: [0, 1e6], start: 2000, step: 100 }

    ask: (options) ->

      minSlider = options.sliders['Minimum']
      maxSlider = options.sliders['Maximum']
      minimum = parseInt minSlider.value
      maximum = parseInt maxSlider.value
      if maximum < minimum
        [maximum, minimum] = [minimum, maximum]

      number = random(minimum, maximum)
      koreanNumber = getKorean number

      if options.questionLanguage is 'korean'
        question = koreanNumber
        answer = number
      else
        question = number.format()
        answer = koreanNumber

      return question

    check: (yourAnswer) ->
      yourAnswer = yourAnswer.toString().replace(/\s+/g, '')
      theAnswer = answer.toString().replace(/\s+/g, '')
      return yourAnswer is theAnswer

    rightAnswer: -> answer.format()
