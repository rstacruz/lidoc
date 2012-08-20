require 'test/env'
_ = require 'underscore'

files = [
  'test/fixture/README.md'
  'test/fixture/actor.js'
  'test/fixture/parser.js'
  'test/fixture/no_comments.js'
]
Vows
  .describe('Lidoc serialization')
  .addBatch
    'Serialization':
      topic: ->
        options = files: files, quiet: true

        Lidoc.parse options, (project) =>
          @callback null, project

      'JSONed': ->
        topic: (project) ->
          JSON.parse(JSON.stringify(project))

        'should be ok': (project) ->
          assert.isObject project.files
          assert.isObject project.files['test/fixture/README.md']

      'reserialized':
        topic: (original) ->
          restored = new Lidoc.Project(JSON.parse(JSON.stringify(original)))
          @callback null, [original, restored]

        'files': ([original, restored]) ->
          assert.equal JSON.stringify(restored.files), JSON.stringify(original.files)

  .export(module)
