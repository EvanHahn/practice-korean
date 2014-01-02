sample = (array) -> array[Math.floor(Math.random() * array.length)]

$(document).ready ->

  jsonData = $.parseJSON($('#vocab-data').html())
  words = jsonData.words

  startAsking

    languageSelect: true

    ask: (options) ->

      word = sample words

      question = word[options.questionLanguage]
      answer = word[options.answerLanguage]

      return { question, answer }
