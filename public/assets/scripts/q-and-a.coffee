sample = (array) -> array[Math.floor(Math.random() * array.length)]
after = (time, fn, args...) -> setTimeout fn, time, args...

@startAsking = (options) ->

  $container = $('#q-and-a-container')

  $question = null
  $answerInput = null
  question = null
  rightAnswer = null

  passOptions = {}

  do -> # add options forms

    $optionsForm = $('<form class="options"></form>')

    if options.languageSelect

      $control = $('<div></div>')
      $languageSelectLabel = $('<label for="q-and-a-language-select">Start with</label>')
      $languageSelect = $ """
        <select id="q-and-a-language-select">
          <option value="either">either language</option>
          <option value="english">English</option>
          <option value="korean">Korean</option>
        </select>"""
      $control.append $languageSelectLabel, ' ', $languageSelect
      $optionsForm.append $control

      passOptions.languageSelection = 'either'

      $languageSelect.on 'change', (event) ->
        passOptions.languageSelection = event.target.value
        newQuestion()

    $container.append $optionsForm if $optionsForm.text()

  do -> # add question and answer elements

    $question = $('<div class="question news"></div>')

    $answerForm = $('<form class="answer"></form>')
    $answerInput = $('<input type="text" placeholder="..."></input>')
    $answerForm.append $answerInput

    $answerForm.on 'submit', ->
      if $.trim $answerInput.val()
        checkAnswer($answerInput.val())
      return false # don't really submit

    $container.append $question, $answerForm

  newQuestion = ->

    lang = passOptions.languageSelection
    if lang?
      if lang is 'either'
        passOptions.questionLanguage = sample ['english', 'korean']
      else
        passOptions.questionLanguage = lang
      if passOptions.questionLanguage is 'english'
        passOptions.answerLanguage = 'korean'
      else
        passOptions.answerLanguage = 'english'

    output = options.ask(passOptions)

    question = output.question
    rightAnswer = output.answer

    $question.text(question).removeClass('good bad')
    $answerInput.val('').focus()

  checkAnswer = (answer) ->
    yourAnswer = answer.toLowerCase()
    $question.text(question).removeClass('good bad')
    $question.text(question).append ": <strong>#{rightAnswer}</strong>"
    if yourAnswer isnt rightAnswer.toString().toLowerCase()
      $question.addClass 'bad'
      $question.append " (<strike>#{yourAnswer}</strike>)"
      $answerInput.val('')
    else
      $question.addClass 'good'
      after 1000, newQuestion

  newQuestion()
