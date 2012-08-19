require 'test/env'
fs = require 'fs'
path = require 'path'
os = require 'os'
rimraf = require 'rimraf'

files = [
  'test/fixture/README.md'
  'test/fixture/actor.js'
  'test/fixture/parser.js'
]

Vows
  .describe('Lidoc builder')
  .addBatch
    'Builder':
      topic: ->
        @output = path.join os.tmpDir(), "lidoc#{Math.random()}"
        options = files: files, quiet: true, output: @output, github: 'abc/def', gitBranch: 'master'

        Lidoc.parse options, (project) =>
          Lidoc.build project, options, =>
            @callback()

      'should build files': ->
        files = [
          'index.html'
          'test/fixture/actor.html'
          'style.css'
          'script.js'
        ]
        files.forEach (file) =>
          fn = path.join(@output, file)
          assert.nonEmptyFile fn

      'index.html':
        topic: ->
          fn = path.join(@output, 'test/fixture/parser.html')
          fs.readFile fn, (err, data) =>
            @callback err, data.toString()

        'link to page and heading': (data) ->
          assert data.indexOf('test/fixture/parser.html#parse') > -1
        'link to home page': (data) ->
          assert data.indexOf('../../index.html') > -1
        'link to another file': (data) ->
          assert data.indexOf('test/fixture/actor.html#f') > -1
        'github source link': (data) ->
          assert data.indexOf('github.com/abc/def/blob/master/test/fixture/parser.js') > -1

      teardown: ->
        rimraf @output, (err, result) ->

  .export(module)
