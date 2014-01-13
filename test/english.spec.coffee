should = require('chai').should()

english = require '../client/scripts/lib/english'

describe 'English', ->

  describe 'sentence module', ->

    describe 'builds', ->

      build = null
      beforeEach ->
        build = english.sentence.build

      it 'sentences with an "I" subject and verb', ->
        sentence = build
          subject: { english: 'I' }
          verb: { english: { i: 'eat' } }
        sentence.should.equal 'I eat.'

      it 'sentences with a "you" subject and verb', ->
        sentence = build
          subject: { english: 'you' }
          verb: { english: { you: 'eat' } }
        sentence.should.equal 'You eat.'

      it 'sentences with an "it" subject and verb', ->
        sentence = build
          subject: { english: 'Yuna' }
          verb: { english: { it: 'eats' } }
        sentence.should.equal 'Yuna eats.'

      it 'sentences with an "I" subject and adjective', ->
        sentence = build
          subject: { english: 'I' }
          adjective: { english: 'tall' }
        sentence.should.equal 'I am tall.'

      it 'sentences with a "you" subject and adjective', ->
        sentence = build
          subject: { english: 'you' }
          adjective: { english: 'cool' }
        sentence.should.equal 'You are cool.'

      it 'sentences with an "it" subject and adjective', ->
        sentence = build
          subject: { english: 'Mina' }
          adjective: { english: 'pretty' }
        sentence.should.equal 'Mina is pretty.'

      it 'sentences with a subject, object, and verb', ->
        sentence = build
          subject: { english: 'Mina' }
          object: { english: 'kimchi' }
          verb: { english: { it: 'eats' } }
        sentence.should.equal 'Mina eats kimchi.'

      it 'exclamations with a subject and verb', ->
        sentence = build
          exclamation: yes
          subject: { english: 'Yuna' }
          verb: { english: { it: 'eats' } }
        sentence.should.equal 'Yuna eats!'

      it 'questions with an "I" subject and verb', ->
        sentence = build
          question: yes
          subject: { english: 'I' }
          verb: { english: { i: 'eat', you: 'eat', it: 'eats' } }
        sentence.should.equal 'Do I eat?'

      it 'questions with a "you" subject and verb', ->
        sentence = build
          question: yes
          subject: { english: 'you' }
          verb: { english: { i: 'eat', you: 'eat', it: 'eats' } }
        sentence.should.equal 'Do you eat?'

      it 'questions with an "it" subject and verb', ->
        sentence = build
          question: yes
          subject: { english: 'Yuna' }
          verb: { english: { i: 'eat', you: 'eat', it: 'eats' } }
        sentence.should.equal 'Does Yuna eat?'

      it 'questions with an "I" subject and adjective', ->
        sentence = build
          question: yes
          subject: { english: 'I' }
          adjective: { english: 'red' }
        sentence.should.equal 'Am I red?'

      it 'questions with a "you" subject and adjective', ->
        sentence = build
          question: yes
          subject: { english: 'you' }
          adjective: { english: 'red' }
        sentence.should.equal 'Are you red?'

      it 'questions with an "it" subject and adjective', ->
        sentence = build
          question: yes
          subject: { english: 'Yuna' }
          adjective: { english: 'red' }
        sentence.should.equal 'Is Yuna red?'

    describe 'checks', ->

      check = null
      beforeEach ->
        check = english.sentence.check

      it 'sentences with an "I" subject, object, and verb', ->

        sen =
          subject: { english: 'I' }
          object: { english: 'kimchi' }
          verb: { english: { i: 'eat', you: 'eat', it: 'eats' } }

        check('I eat kimchi', sen).should.be.true
        check('i eat kimchi', sen).should.be.true
        check('i EAt kIMcHi', sen).should.be.true
        check('I EAT KIMCHI', sen).should.be.true
        check('I eat kimchi.', sen).should.be.true
        check('I eat kimchi!', sen).should.be.true

        check('I I eat kimchi', sen).should.be.false
        check('I eat kimchi?', sen).should.be.false
        check('eat kimchi', sen).should.be.false
        check('I kimchi', sen).should.be.false
        check('I eat', sen).should.be.false
        check('eat I kimchi', sen).should.be.false
        check('I kimchi eat', sen).should.be.false

      it 'sentences with an "I" subject and adjective', ->

        sen =
          subject: { english: 'I' }
          adjective: { english: 'blue' }

        check('I am blue', sen).should.be.true
        check('i am blue', sen).should.be.true
        check("I'm blue", sen).should.be.true
        check('I am blue.', sen).should.be.true
        check('I am blue!', sen).should.be.true
        check('I am...blue.', sen).should.be.true

        check('I I am blue', sen).should.be.false
        check("I'm am blue", sen).should.be.false
        check('I blue am', sen).should.be.false
        check('blue I am', sen).should.be.false
        check('I are blue', sen).should.be.false
        check('I is blue', sen).should.be.false
        check('am blue', sen).should.be.false
        check('blue', sen).should.be.false
        check('I am', sen).should.be.false

      it 'questions with an "I" subject and a verb', ->

        sen =
          question: yes
          subject: { english: 'I' }
          verb: { english: { i: 'eat', you: 'eat', it: 'eats' } }

        check('Do I eat?', sen).should.be.true
        check('do I eat?', sen).should.be.true
        check('do i eat?', sen).should.be.true
        check('I eat?', sen).should.be.true
        check('i eat?', sen).should.be.true

        check('Do I eat', sen).should.be.false
        check('Do I eat!', sen).should.be.false
        check('is I eat?', sen).should.be.false
        check('Do eat?', sen).should.be.false
        check('Do I?', sen).should.be.false
        check('Does I eat?', sen).should.be.false
        check('Did I eat?', sen).should.be.false
        check('Do I drink?', sen).should.be.false
        check('Do you eat?', sen).should.be.false
        check('Do I am eat?', sen).should.be.false
        check("Do I'm eat?", sen).should.be.false

      it 'questions with an "I" subject and an adjective', ->

        sen =
          question: yes
          subject: { english: 'I' }
          adjective: { english: 'tall' }

        check('Am I tall?', sen).should.be.true
        check('am i tall?', sen).should.be.true
        check('AM I TALL?', sen).should.be.true
        check('I am tall?', sen).should.be.true
        check("I'm tall?", sen).should.be.true

        check('Am I short?', sen).should.be.false
        check('Is I tall?', sen).should.be.false
        check('Are I tall?', sen).should.be.false
        check('Am I am tall?', sen).should.be.false
        check("Am I'm tall?", sen).should.be.false
        check('Am I tall', sen).should.be.false
        check('Am I?', sen).should.be.false
        check('I tall?', sen).should.be.false
        check('tall?', sen).should.be.false
        check('Am I tall!', sen).should.be.false
        check('Am I tall.', sen).should.be.false
        check('I am tall', sen).should.be.false
        check('I am tall.', sen).should.be.false
        check('I am tall!', sen).should.be.false
        check("I'm am tall?", sen).should.be.false
        check('I am?', sen).should.be.false
