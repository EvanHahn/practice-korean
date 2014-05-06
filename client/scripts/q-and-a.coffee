require 'sugar'
sample = require './lib/sample.coffee'
after = require './lib/after.coffee'

module.exports = (options) ->

  $container = $('#q-and-a-container')

  $question = null
  $questionText = null
  $questionRight = null
  $questionYours = null
  $answerInput = null

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

    if options.sliders
      sliders = options.sliders
      passOptions.sliders = {}
    else
      sliders = {}

    Object.keys(sliders).forEach (sliderName) ->

      sliderOptions = sliders[sliderName]
      minimum = sliderOptions.range[0]
      maximum = sliderOptions.range[1]
      startAt = sliderOptions.start
      step = sliderOptions.step or 1

      $control = $('<div></div>')
      $label = $('<label></label>')
      $label.prop('for', sliderName.dasherize())
      $label.text(sliderName)
      $slider = $('<input type="range"></input>')
      $slider.prop('min', minimum)
      $slider.prop('max', maximum)
      $slider.prop('step', step)
      $slider.val(startAt)
      $slider.prop('id', sliderName.dasherize())
      $value = $('<span><span>')
      $value.text(startAt)

      $control.append $label, ' ', $slider, ' ', $value
      $optionsForm.append $control

      passOptions.sliders[sliderName] = $slider.get(0)

      $slider.on 'change', (event) ->
        $value.text($slider.val())
        newQuestion()

    $container.append $optionsForm if $optionsForm.text()

  do -> # add question and answer elements

    $question = $('<div class="question news"></div>')
    $questionText = $('<div class="question-text"></div>')
    $questionRight = $('<div class="question-right"></div>')
    $questionYours = $('<div class="question-yours"></div>')
    $question.append $questionText, $questionRight, $questionYours

    $answerForm = $('<form class="answer"></form>')
    $answerInput = $('<input type="text" placeholder="..."></input>')
    $answerForm.append $answerInput

    $answerForm.on 'submit', ->
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

    question = options.ask(passOptions)

    $question.removeClass 'good bad'
    $questionText.text(question)
    $questionRight.text('')
    $questionYours.text('')
    $answerInput.val('').focus()

  checkAnswer = (yourAnswer) ->

    correct = options.check(yourAnswer)

    $question.removeClass 'good bad'
    $questionRight.text(options.rightAnswer())

    if correct
      $questionYours.text('')
      $question.addClass 'good'
      after 1000, newQuestion

    else
      $questionYours.text(yourAnswer)
      $question.addClass 'bad'
      $answerInput.val('')

  newQuestion()
