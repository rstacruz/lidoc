require 'test/env'

files = [
  'test/fixture/README.md'
  'test/fixture/guides.md'
  'test/fixture/guides/getting_started.md'
  'test/fixture/recipes/using_git.md'
]

Vows
  .describe('Lidoc page tree')
  .addBatch
    "The project's":
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
          assert.equal file.sourceFile, 'test/fixture/guides/getting_started.md'

      'pageTree index':
        topic: (project) ->
          [ project, project.pageTree ]

        'should exist': ([project, tree]) ->
          assert.isObject project.pageTree

        "'s root page":
          'should have a title': ([project, tree]) ->
            assert.equal tree.title, 'Hello'

          'should have the right source file': ([project, tree]) ->
            page = project.pages[tree.pageID]
            file = project.files[page.file]

            assert.equal file.sourceFile, 'test/fixture/README.md'

        "'s 1st-level page should exist": ([project, tree]) ->
          assert.isObject tree.paths['Guides']
          assert.equal tree.paths['Guides'].pageID, 'Guides'

        "'s 2nd-level page should exist": ([project, tree]) ->
          assert.isObject tree.paths['Guides'].paths['Getting started']
          assert.equal tree.paths['Guides'].paths['Getting started'].pageID, 'Guides: Getting started'

        "'s inferred page should exist": ([project, tree]) ->
          assert.isObject tree.paths['Recipes']
          assert.isNull tree.paths['Recipes'].pageID

        "'s inferred page's child should exist": ([project, tree]) ->
          assert.isObject tree.paths['Recipes'].paths['Updating Git']
          assert.isNull tree.paths['Recipes'].pageID

  .export(module)
