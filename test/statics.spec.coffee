supertest = require 'supertest'
app = require '../server/app'

request = supertest app

describe 'static files', ->

  it 'responds with an HTML root, a compiled page', (done) ->
    request.get('/')
    .expect('Content-Type', /html/)
    .expect(200, done)

  it 'has /the.css, a compiled stylesheet', (done) ->
    request.get('/the.css')
    .expect('Content-Type', /css/)
    .expect(200, done)

  it 'has /vocab.js, a compiled script', (done) ->
    request.get('/vocab.js')
    .expect('Content-Type', /javascript/)
    .expect(200, done)

  it 'has /jquery.js, a purely-static file', (done) ->
    request.get('/jquery.js')
    .expect('Content-Type', /javascript/)
    .expect(200, done)