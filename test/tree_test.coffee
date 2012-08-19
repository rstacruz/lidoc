require "test/env"
Lidoc = require "lib/lidoc"

files = [
  'test/fixture/README.md',
  'test/fixture/parser.js'
]

Vows
  .describe('Lidoc parser')
  .addBatch
    'tree':
      topic: ->
        Lidoc.parse files: files, quiet: true, (project) =>
          @callback null, project.getFileTree()

      'should be the right type': (tree) ->
        assert.equal tree.constructor, require("lib/lidoc/filetree")

      'paths':
        './': (tree) ->
          assert.equal tree.name, ''

        './test/': (tree) ->
          assert.equal tree.paths['test'].name, 'test'

        './test/fixture/': (tree) ->
          assert.equal tree.paths['test'].paths['fixture'].name, 'fixture'

        './test/fixture/parser.html': (tree) ->
          file = tree.paths['test'].paths['fixture'].paths['parser.html']
          assert.equal file.sourceFile, 'test/fixture/parser.js'

  .export(module)
