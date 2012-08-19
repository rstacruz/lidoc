require 'test/env'

Vows
  .describe('Lidoc builder')
  .addBatch
    'Builder':
      topic: ->
        options = files: files, quiet: true

        Lidoc.parse options, (project) =>
          Lidoc.build project, options

      'should have version': ->
        assert.isString Lidoc.version
        assert Lidoc.version.match /^[0-9]+\.[0-9]+\.[0-9]+/
      'should have methods': ->
        assert.isFunction Lidoc.parse
        assert.isFunction Lidoc.build

  .export(module)
