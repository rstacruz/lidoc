require "test/env"
Lidoc = require "lib/lidoc"

files = [
  'test/fixture/README.md',
  'test/fixture/parser.js',
  'test/fixture/actor.js'
]

Vows
  .describe('Lidoc parser')
  .addBatch
    'tree':
      topic: ->
        Lidoc.parse files: files, quiet: true, (project) =>
          @callback null, project.fileTree

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
          node = tree.paths['test'].paths['fixture'].paths['parser.html']
          assert.equal node.file, 'test/fixture/parser.html'

      'ensure sorted': (tree) ->
        folder = tree.paths['test'].paths['fixture']

        names = []
        for name, file of folder.paths
          names.push name

        assert.equal names.join(","), ["actor.html","parser.html"]

  .export(module)
