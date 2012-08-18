require "test/env"
Lidoc = require "lib/lidoc"

Vows
  .describe('Lidoc')
  .addBatch
    'Lidoc':
      'should have version': ->
        assert.isString Lidoc.version
        assert Lidoc.version.match /^[0-9]+\.[0-9]+\.[0-9]+/
      'should have methods': ->
        assert.isFunction Lidoc.parse
        assert.isFunction Lidoc.build

  .export(module)
