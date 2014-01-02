startWith = 'either'

sample = (array) -> array[Math.floor(Math.random() * array.length)]
after = (time, fn, args...) -> setTimeout fn, time, args...

$(document).ready ->

  jsonData = $.parseJSON($('#vocab-data').html())
  words = jsonData.words

  $container = $('#vocab-container')

  $question = null
  $answerInput = null
  question = null
  rightAnswer = null

  do -> # add options forms

    $optionsForm = $('<form class="options"></form>')
    $languageSelectLabel = $('<label for="vocab-language-select">Start with</label>')
    $languageSelect = $ """
      <select id="vocab-language-select">
        <option value="either">either language</option>
        <option value="english">English</option>
        <option value="korean">Korean</option>
      </select>"""
    $optionsForm.append $languageSelectLabel, ' ', $languageSelect

    $languageSelect.on 'change', (event) ->
      startWith = event.target.value
      newQuestion()

    $container.append $optionsForm

  do -> # add question and answer elements

    $question = $('<div class="vocab-question news"></div>')

    $answerForm = $('<form class="vocab-answer"></form>')
    $answerInput = $('<input type="text" placeholder="..."></input>')
    $answerForm.append $answerInput

    $answerForm.on 'submit', ->
      if $.trim $answerInput.val()
        checkAnswer($answerInput.val())
      return false # don't really submit

    $container.append $question, $answerForm

  newQuestion = ->

    word = sample words

    if startWith is 'either'
      questionLanguage = sample ['english', 'korean']
    else
      questionLanguage = startWith

    if questionLanguage is 'english'
      answerLanguage = 'korean'
    else
      answerLanguage = 'english'

    question = word[questionLanguage]
    rightAnswer = word[answerLanguage]

    $question.text(question).removeClass('good bad')
    $answerInput.val('').focus()

  checkAnswer = (answer) ->
    yourAnswer = answer.toLowerCase()
    $question.text(question).removeClass('good bad')
    $question.text(question).append ": <strong>#{rightAnswer}</strong>"
    if yourAnswer isnt rightAnswer.toLowerCase()
      $question.addClass 'bad'
      $question.append " (<strike>#{yourAnswer}</strike>)"
      $answerInput.val('')
    else
      $question.addClass 'good'
      after 1000, newQuestion

  newQuestion()
