# # Models: FileNode

# Represents a hierarchal index of a bunch of files.
#
# Each node represents either a true file or a folder.  This means that each
# FileNode may or may not have a Page associated wiht it.
#
#     tree = new Lidoc.FileNode(files)
#
#     tree ==
#       name: '.'
#       paths:
#         'app':
#           name: 'app'
#           paths:
#             'file.js':
#               name: 'file.js'
#               fileID: 'app/file.js'
#         'README.md':
#           name: 'README.md'
#           fileID: 'README.md'
#
#     # File (assets/javascripts/parser.html)
#     tree.paths['assets'].paths['javascripts'].paths['parser.html']
#
# You can get this from `Project.index.fileTree`, or `fileTree` in the HTML
# template.

path = require 'path'
datastruct = require '../../datastruct'

class FileNode
  datastruct this

  @property
    'name':    default: ''
    'fileID':  default: ''
    'paths':   default: {}, subtype: FileNode

  constructor: (options={}, parent) ->
    if parent?.constructor is FileNode
      @parent  = parent
      @project = parent.project
    else if parent?.files # Project
      @project = parent

    @set options

  # ### file
  # Returns the associated `File`.
  @property 'file', hidden: true, get: ->
    @project.files[@fileID]

  # ### buildFrom()

  # Takes `files` from a {Project} and builds a filetree from it.
  #
  buildFrom: (@project) ->
    for i, file of @project.files
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
      @paths[segments[0]] = new FileNode(name: segments[0], fileID: file.id, this)

    else
      @paths[segments[0]] ?= new FileNode(name: segments[0], this)
      @paths[segments[0]].addFile segments.slice(1), file

    this

module.exports = FileNode
