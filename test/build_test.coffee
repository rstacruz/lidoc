require 'test/env'
fs = require 'fs'
path = require 'path'
os = require 'os'
rimraf = require 'rimraf'
JsDom = require 'jsdom'

files = [
  'test/fixture/README.md'
  'test/fixture/actor.js'
  'test/fixture/parser.js'
  'test/fixture/no_comments.js'
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
          'test/fixture/parser.html'
          'test/fixture/no_comments.html'
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
            @callback err, JsDom.jsdom(data.toString(), null, features: QuerySelector: true)

        'link to heading': (document) ->
          assert document.querySelectorAll('[href="#parse"]').length >= 1
        'link to home page [fails]': (document) ->
          assert.equal document.querySelectorAll('[href$="../../index.html"]').length, 1
        'link to another file': (document) ->
          assert.equal document.querySelectorAll('[href*="test/fixture/actor.html"]').length, 1
        'github source link': (document) ->
          assert.equal document.querySelectorAll('[href="https://github.com/abc/def/blob/master/test/fixture/parser.js"]').length, 1

      teardown: ->
        rimraf @output, (err, result) ->

  .export(module)
