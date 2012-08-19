# # Lidoc.Filetree

path = require 'path'

#     tree = new Filetree(files)
#
#     tree ==
#       name: '.'
#       paths:
#         'app':
#           name: 'app'
#           paths:
#             'file.js': {File}
#         'README.md': {File}
#
class Filetree
  constructor: (options={}) ->
    @name = options.name ? ""
    @paths = {}

  # ### buildFrom()

  # Takes `files` from a {Project} and builds a filetree from it.
  #
  buildFrom: (files) ->
    for i, file of files
      name = file.htmlFile
      segments = name.split(path.sep)

      @addFile segments, file

    this

  addFile: (segments, file) ->
    if segments.length is 1
      @paths[segments[0]] = file

    else
      @paths[segments[0]] ?= new Filetree(name: segments[0])
      @paths[segments[0]].addFile segments.slice(1), file

    this

module.exports = Filetree
