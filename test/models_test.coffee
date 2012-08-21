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
        topic: (project) ->
          project.pages['Guides: Getting started']

        'should be the right type': (page) ->
          assert.equal page.constructor, Lidoc.Page

        'should have a project': (page) ->
          assert.equal page.project.constructor, Lidoc.Project



  .export(module)
