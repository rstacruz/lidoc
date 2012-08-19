require 'test/env'
fs = require 'fs'
path = require 'path'

assert.nonEmptyFile = (fname) ->
  fs.readFile fname, (err, data) ->
    assert.isNull err
    assert data.length > 0

files = [
  'test/fixture/README.md'
]

Vows
  .describe('Lidoc builder')
  .addBatch
    'Builder':
      topic: ->
        @output = "/tmp/lidoc#{Math.random()}"
        options = files: files, quiet: true, output: @output

        Lidoc.parse options, (project) =>
          Lidoc.build project, options, =>
            @callback()

      'should build':
        'index.html': ->
          fn = path.join(@output, 'index.html')
          assert.nonEmptyFile fn
        'style.css': ->
          fn = path.join(@output, 'style.css')
          assert.nonEmptyFile fn

      teardown: ->
        fs.rmdir @output

  .export(module)
