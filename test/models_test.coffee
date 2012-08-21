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
          project.files['test/fixture/guides/getting_started.md']

        'should be the right type': (file) ->
          assert.equal file.constructor, Lidoc.File

        'should have a project': (file) ->
          assert.equal file.project.constructor, Lidoc.Project

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

  .export(module)
