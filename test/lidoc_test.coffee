require "test/env"
Lidoc = require "lib/lidoc"

Vows
  .describe('Lidoc')
  .addBatch
    'context':
      topic: ->
        100
      'should work': (number) ->
        assert.equal number, 100

  .export(module)
