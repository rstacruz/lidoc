require 'test/env'

files = [
  'test/fixture/tree-1.md'
  'test/fixture/tree-2.md'
  'test/fixture/tree-3.md'
]

Vows
  .describe('Lidoc page tree')
  .addBatch
    'Page tree':
      topic: ->
        Lidoc.parse files: files, quiet: true, (project) =>
          @callback null, project

      'Page 1':
        topic: (project) ->
          [ project, project.pages['Guides: Getting started'] ]

        '.title': ([project, page]) ->
          assert.equal page.title, "Getting started"

        '.segments': ([project, page]) ->
          assert.equal page.segments.join("/"), "Guides/Getting started"

        '.file': ([project, page]) ->
          file = project.files[page.file]
          assert.equal file.sourceFile, 'test/fixture/tree-2.md'

      'pageTree index':
        topic: (project) ->
          [ project, project.pageTree ]

        'exists': ([project, tree]) ->
          assert.isObject project.pageTree

        'stuff': ([project, tree]) ->
          assert.equal tree.name, ''

          assert.isObject tree.paths['Guides']
          assert.equal tree.paths['Guides'].page, 'Guides'

          assert.isObject tree.paths['Guides'].paths['Getting started']
          assert.equal tree.paths['Guides'].paths['Getting started'].page, 'Guides: Getting started'

        'Inferred page': ([project, tree]) ->
          assert.isObject tree.paths['Recipes']
          assert.isNull tree.paths['Recipes'].page

        'Child of inferred page': ([project, tree]) ->
          assert.isObject tree.paths['Recipes'].paths['Updating Git']
          assert.isNull tree.paths['Recipes'].page

  .export(module)
