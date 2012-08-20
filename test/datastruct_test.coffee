require 'test/env'
datastruct = require 'lib/datastruct'

Vows
  .describe('Datastruct')
  .addBatch
    'Datastruct':
      topic: ->
        class Book
          datastruct this
          @property 'author', default: ''
          @property 'title', default: ''

          getNumber: -> 2

          @property 'number', getter: @::getNumber
          @property 'isbn',
            getter: ->
              'a123'

          constructor: (options={}) ->
            @set options

      'instanciating':
        'should use all options': (klass) ->
          inst = new klass author: 'rico', title: 'hi'
          assert.equal inst.author, 'rico'
          assert.equal inst.title, 'hi'

        'should use defaults': (klass) ->
          inst = new klass author: 'rico'
          assert.equal inst.author, 'rico'
          assert.equal inst.title, ''

        'should discard non-properties': (klass) ->
          inst = new klass body: 'hi'
          assert.isUndefined inst.body

      'getters':
        'should work with strings': (klass) ->
          inst = new klass
          assert.equal inst.number, 2

        'should work with functions': (klass) ->
          inst = new klass
          assert.equal inst.isbn, 'a123'

      '.toJSON()':
        topic: (klass) ->
          inst = new klass title: "World"
          inst._id = 42
          json = inst.toJSON()

        'should discard non-properties': (json) ->
          assert.isUndefined json._id

        'should keep property defaults': (json) ->
          assert.isDefined json.author
          assert.equal json.author, ''

        'should use given properties': (json) ->
          assert.equal json.title, 'World'

  .export(module)
