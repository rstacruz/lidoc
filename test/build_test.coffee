require 'test/env'
fs = require 'fs'
path = require 'path'
os = require 'os'
rimraf = require 'rimraf'

files = [
  'test/fixture/README.md'
  'test/fixture/actor.js'
]

Vows
  .describe('Lidoc builder')
  .addBatch
    'Builder':
      topic: ->
        @output = path.join os.tmpDir(), "lidoc#{Math.random()}"
        options = files: files, quiet: true, output: @output

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

      teardown: ->
        rimraf @output, (err, result) ->

  .export(module)
