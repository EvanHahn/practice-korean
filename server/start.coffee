app = require './app'

app.listen process.env.PORT, ->
  console.log "App started in #{app.get 'env'} mode on #{process.env.PORT}"
