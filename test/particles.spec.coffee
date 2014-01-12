require('chai').should()

particles = require '../client/scripts/lib/particles'
add = particles.add
object = particles.object
topic = particles.topic
subject = particles.subject

describe 'Korean particle finder', ->

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
