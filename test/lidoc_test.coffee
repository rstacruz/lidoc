require "test/env"
Lidoc = require "lib/lidoc"

Vows
  .describe('Lidoc')
  .addBatch
    'Lidoc':
      topic: ->
        Lidoc
      'should have methods': (number) ->
        assert.isFunction Lidoc.parse
        assert.isFunction Lidoc.build

  .export(module)
