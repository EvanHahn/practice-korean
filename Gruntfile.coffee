loadTasks = require 'load-grunt-tasks'
config = require './common/config'

jadeOptions = {}
browserifyOptions = {}
stylusOptions = {}
uglifyOptions = {}

for page in config.compiledPages
  jadeOptions["tmp/serve/#{page}.html"] = "client/pages/#{page}.jade"

for style in config.compiledStyles
  stylusOptions["tmp/serve/#{style}.css"] = "client/styles/#{style}.styl"

for script in config.compiledScripts
  outPath = "tmp/serve/#{script}.js"
  browserifyOptions[script] =
    src: "client/scripts/#{script}.coffee"
    dest: outPath
    options: { transform: ['coffeeify'] }
  uglifyOptions[outPath] = outPath

module.exports = (grunt) ->

  grunt.initConfig

    jade: { compile: { files: jadeOptions } }

    browserify: browserifyOptions

    stylus:
      compile:
        options: { paths: ['client/styles'] }
        files: stylusOptions

    uglify:
      javascripts:
        files: uglifyOptions

    watch:
      # atBegin: yes
      pages:
        files: ['client/pages/**/*', 'config.json']
        tasks: ['jade']
      scripts:
        files: ['client/scripts/**/*', 'config.json']
        tasks: ['browserify']
      styles:
        files: ['client/styles/**/*']
        tasks: ['stylus']

    loadTasks grunt

    grunt.registerTask 'default', ['jade', 'browserify', 'stylus', 'uglify']
