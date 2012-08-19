require "test/env"

files = [
  'test/fixture/README.md',
  'test/fixture/parser.js'
]

Vows
  .describe('Lidoc parser')
  .addBatch
    'Parsing the fixture':
      topic: ->
        Lidoc.parse files: files, quiet: true, (project) =>
          @callback null, project

      'should have pages': (project) ->
        assert.isObject project.pages

      'should have files': (project) ->
        assert.isObject project.files

      'README':
        topic: (project) ->
          project.files['test/fixture/README.md']

        'should have an index.html': (readme) ->
          assert.equal readme.htmlFile, 'index.html'

        'should have the right sourceFile': (readme) ->
          assert.equal readme.sourceFile, 'test/fixture/README.md'

        'should have the correct number of sections': (readme) ->
          assert.equal readme.sections.length, 3

      'parser.js':
        topic: (project) ->
          project.files['test/fixture/parser.js']

        'should have the right attributes': (file) ->
          assert.equal file.htmlFile, 'test/fixture/parser.html'
          assert.equal file.sourceFile, 'test/fixture/parser.js'

        'should have a main heading': (file) ->
          assert.equal file.mainHeading.level, 1
          assert.equal file.mainHeading.title, 'Parser object'

        'sections should have something': (file) ->
          assert.isArray file.sections
          file.sections.forEach (section) ->
            assert.isString section.docsHtml
            assert.isString section.codeHtml
            assert.isString section.docsText
            assert.isString section.codeText

        'sections should have anchors': (file) ->
          assert.equal file.sections[0].anchor, 'Parser-object'
          assert.equal file.sections[1].anchor, 'parse'

        'sections should have headings': (file) ->
          file.sections.forEach (section) ->
            assert.isArray section.headings
            assert section.headings.length >= 0

        'sections should have rendered': (file) ->
          file.sections.forEach (section) ->
            assert section.docsHtml.length >= 0

  .export(module)
