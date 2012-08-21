require 'test/env'

files = [
  'test/fixture/README.md'
  'test/fixture/guides.md'
  'test/fixture/guides/getting_started.md'
  'test/fixture/recipes/using_git.md'
]

Vows
  .describe('Lidoc models')
  .addBatch
    'Lidoc models':
      topic: ->
        Lidoc.parse files: files, quiet: true, (project) =>
          @callback null, project

      'A file':
        topic: (project) ->
          file = project.files['test/fixture/guides/getting_started.md']
          [project, file]

        'should be the right type': ([project, file]) ->
          assert.equal file.constructor, Lidoc.File

        '.project': ([project, file]) ->
          assert.equal file.project.constructor, Lidoc.Project

        '.page': ([project, file]) ->
          assert.equal file.page, project.pages['Guides: Getting started']

      'A page':
        '1':
          topic: (project) ->
            project.pages['Guides: Getting started']

          'should be the right type': (page) ->
            assert.equal page.constructor, Lidoc.Page

          'should have a project': (page) ->
            assert.equal page.project.constructor, Lidoc.Project

          '.node': (page) ->
            node = page.node
            assert.equal node.title, page.title

        'parenting':
          topic: (project) ->
            page   = project.pages['Guides: Getting started']
            parent = project.pages['Guides']

            [page, parent]

          '.parentNode': ([page, parent]) ->
            assert.equal page.parentNode, parent.node

          '.parentPage': ([page, parent]) ->
            assert.equal page.parentPage, parent

      'A pagetree node':
        topic: (project) ->
          page = project.pages['Guides: Getting started']
          [project, page, page.node]

        '.project': ([project, page, node]) ->
          assert.equal node.project, project

        '.page': ([project, page, node]) ->
          assert.equal node.page, page

      'A filetree node': ->
        topic: (project) ->
          file = project.files['test/fixture/guides/getting_started.md']
          [project, file, file.node]

  .export(module)
