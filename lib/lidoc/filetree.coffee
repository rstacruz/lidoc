# # Lidoc.Filetree

# Represents a hierarchal index of a bunch of files.
#
#     tree = new Lidoc.Filetree(files)
#
#     tree ==
#       name: '.'
#       paths:
#         'app':
#           name: 'app'
#           paths:
#             'file.js':
#               name: 'file.js'
#               file: {File}
#         'README.md':
#           name: 'file.js'
#           file: {File}
#
#     # File (assets/javascripts/parser.html)
#     tree.paths['assets'].paths['javascripts'].paths['parser.html']
#
# You can get this from `Project.index.fileTree`, or `fileTree` in the HTML
# template.

path = require 'path'

class Filetree
  constructor: (options={}) ->
    @name = options.name ? ""
    @file = options.file ? null
    @paths = {}

  # ### buildFrom()

  # Takes `files` from a {Project} and builds a filetree from it.
  #
  buildFrom: (files) ->
    for i, file of files
      name = file.htmlFile
      segments = name.split(path.sep)

      @addFile segments, file

    @sort()

    this

  # ### sort()

  # Ensures that the paths are sorted.
  sort: ->
    newPaths = {}

    #- Get all the names and sort them
    names = []
    for name, object of @paths
      names.push name

    names = names.sort()

    #- Now put them back in, recursing in the process
    names.forEach (name) =>
      @paths[name].sort()  if typeof @paths[name].sort is 'function'
      newPaths[name] = @paths[name]

    #- And replace the old paths with the new
    delete(@paths)
    @paths = newPaths

    this

  addFile: (segments, file) ->
    if segments.length is 1
      @paths[segments[0]] = new Filetree(name: segments[0], file: file.id)

    else
      @paths[segments[0]] ?= new Filetree(name: segments[0])
      @paths[segments[0]].addFile segments.slice(1), file

    this

module.exports = Filetree
