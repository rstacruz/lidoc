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

          @property 'sections', default: {}

          getNumber: -> 2

          @property 'number', get: @::getNumber
          @property 'isbn', get: ->
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

      'defaults should not bleed': (klass) ->
        inst1 = new klass
        inst1.sections['a'] = 2

        inst2 = new klass
        assert.isEmpty inst2.sections

      'type':
        topic: ->
          class Section
            constructor: (@number, @book) ->

          class Book
            datastruct this
            @property 'section', type: Section
            constructor: (options) -> @set options

          [Section, Book]

        'yes': ([Section, Book]) ->
          book = new Book section: 2
          assert.equal book.section.constructor, Section
          assert.equal book.section.number, 2
          assert.equal book.section.book, book

      'recurse':
        topic: ->
          class Section
            constructor: (@number, @book) ->

          class Book
            datastruct this

            @property 'sections', subtype: Section, default: []

            constructor: (options) -> @set options

          [Section, Book]

        'arrays': ([Section, Book]) ->
          book = new Book sections: [10, 20]

          assert.equal book.sections[0].number, 10
          assert.equal book.sections[1].number, 20

          assert.equal book.sections[0].book, book

        'objects': ([Section, Book]) ->
          book = new Book sections: {a: 10, b: 20}

          assert.equal book.sections['a'].number, 10
          assert.equal book.sections['b'].number, 20

          assert.equal book.sections['b'].book, book

      'multi properties':
        topic: ->
          class Book
            datastruct this

            @property
              'author':   default: ''
              'sections': default: {}

            constructor: (options={}) ->
              @set options

        'should work': (klass) ->
          assert.equal klass.properties['author'].default, ''
          assert.isObject klass.properties['sections'].default
          assert.isEmpty klass.properties['sections'].default

  .export(module)
