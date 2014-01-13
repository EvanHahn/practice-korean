should = require('chai').should()

korean = require '../client/scripts/lib/korean'

add = korean.add
object = korean.object
topic = korean.topic
subject = korean.subject

describe 'Korean', ->

  describe 'sentence module', ->

    describe 'builds', ->

      build = null
      beforeEach ->
        build = korean.sentence.build

      it 'sentences with a subject and verb', ->
        sentence = build
          subject: { korean: '유미' }
          verb: { korean: '노래해요' }
        sentence.should.equal '유미가 노래해요.'

      it 'sentences with 저 as the subject and a verb', ->
        sentence = build
          subject: { korean: '저' }
          verb: { korean: '먹어요' }
        sentence.should.equal '제가 먹어요.'

      it 'sentences with a subject, object, and verb', ->
        sentence = build
          subject: { korean: '민지' }
          object: { korean: '김치' }
          verb: { korean: '먹어요' }
        sentence.should.equal '민지가 김치를 먹어요.'

      it 'sentences with a subject, object, location and verb', ->
        sentence = build
          location: { korean: '집' }
          subject: { korean: '민지' }
          object: { korean: '김치' }
          verb: { korean: '먹어요' }
        sentence.should.equal '집에서 민지가 김치를 먹어요.'

      it 'questions with a subject and verb', ->
        sentence = build
          question: yes
          subject: { korean: '유미' }
          verb: { korean: '노래해요' }
        sentence.should.equal '유미가 노래해요?'

      it 'exclamations with a subject and verb', ->
        sentence = build
          exclamation: yes
          subject: { korean: '유미' }
          verb: { korean: '노래해요' }
        sentence.should.equal '유미가 노래해요!'

      it 'sentences with a subject and adjective', ->
        sentence = build
          subject: { korean: '유미' }
          adjective: { korean: '좋아요' }
        sentence.should.equal '유미가 좋아요.'

    describe 'checks', ->

      check = null
      beforeEach ->
        check = korean.sentence.check

      it 'sentences with subject, object, location, verb', ->

        sen =
          location: { korean: '집' }
          subject: { korean: '민지' }
          object: { korean: '김치' }
          verb: { korean: '먹어요' }

        check('집에서 민지가 김치를 먹어요', sen).should.be.true
        check('집에서 민지가 김치를 먹어요.', sen).should.be.true
        check('집에서 민지가 김치를 먹어요!', sen).should.be.true
        check('집에서 김치를 민지가 먹어요', sen).should.be.true
        check('김치를 집에서 민지가 먹어요', sen).should.be.true

        check('집에 민지가 김치를 먹어요', sen).should.be.false
        check('집에서 민지가 민지가 김치를 먹어요', sen).should.be.false
        check('집에서 민지가 김치를 먹어요?', sen).should.be.false
        check('집에서 민지가 김치을 먹어요', sen).should.be.false
        check('집에서 민지이 김치를 먹어요', sen).should.be.false
        check('집에서 민지가 먹어요 김치를', sen).should.be.false
        check('집에서 먹어요 민지가 김치를', sen).should.be.false
        check('집에서 민지 김치를 먹어요', sen).should.be.false
        check('집에서 민지가 김치 먹어요', sen).should.be.false
        check('집에서 민지 김치 먹어요', sen).should.be.false
        check('집에서 미나가 김치를 먹어요', sen).should.be.false
        check('민지가 음식을 먹어요', sen).should.be.false
        check('민지가 김치를 있어요', sen).should.be.false
        check('민지가 김치를 먹어요', sen).should.be.false
        check('김치를 먹어요', sen).should.be.false
        check('민지가 먹어요', sen).should.be.false
        check('민지가 김치를', sen).should.be.false

      it 'sentences with subject and adjective', ->

        sen =
          subject: { korean: '민지' }
          adjective: { korean: '좋아요' }

        check('민지가 좋아요', sen).should.be.true
        check('민지가 좋아요.', sen).should.be.true
        check('민지가 좋아요!', sen).should.be.true

        check('민지가 민지가 좋아요', sen).should.be.false
        check('민지가 좋아요?', sen).should.be.false
        check('민지는 좋아요', sen).should.be.false
        check('민지이 좋아요', sen).should.be.false
        check('민지가 안좋아요', sen).should.be.false
        check('민지 좋아요', sen).should.be.false
        check('민지가 좋아', sen).should.be.false
        check('좋아요', sen).should.be.false
        check('민지가', sen).should.be.false

  describe 'object function', ->

    it 'chooses 을 properly', ->
      object('책').should.equal '을'
      object('책상').should.equal '을'
      object('수업').should.equal '을'

    it 'chooses 를 properly', ->
      object('의자').should.equal '를'
      object('회사').should.equal '를'

    it 'adds 을 properly', ->
      add.object('책').should.equal '책을'

    it 'adds 를 properly', ->
      add.object('의자').should.equal '의자를'

  describe 'topic function', ->

    it 'chooses 은 properly', ->
      topic('책').should.equal '은'
      topic('책상').should.equal '은'
      topic('수업').should.equal '은'

    it 'chooses 는 properly', ->
      topic('저').should.equal '는'
      topic('의자').should.equal '는'
      topic('회사').should.equal '는'

    it 'adds 은 properly', ->
      add.topic('책').should.equal '책은'
      add.topic('책상').should.equal '책상은'
      add.topic('수업').should.equal '수업은'

    it 'adds 는 properly', ->
      add.topic('저').should.equal '저는'
      add.topic('의자').should.equal '의자는'
      add.topic('회사').should.equal '회사는'

  describe 'subject function', ->

    it 'chooses 이 properly', ->
      subject('책').should.equal '이'
      subject('책상').should.equal '이'
      subject('수업').should.equal '이'

    it 'chooses 가 properly', ->
      subject('저').should.equal '가'
      subject('의자').should.equal '가'
      subject('회사').should.equal '가'

    it 'chooses 이 properly', ->
      add.subject('책').should.equal '책이'
      add.subject('책상').should.equal '책상이'
      add.subject('수업').should.equal '수업이'

    it 'chooses 가 properly', ->
      add.subject('의자').should.equal '의자가'
      add.subject('회사').should.equal '회사가'

    it 'changes 저 to 제가', ->
      add.subject('저').should.equal '제가'

  describe 'activeLocation function', ->

    it 'adds 에서', ->
      add.activeLocation('집').should.equal '집에서'
