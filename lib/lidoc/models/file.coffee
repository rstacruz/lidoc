# # Models: File

# Represents a source file and it's generated HTML file. Stores code/docs in
# `sections`. Looks like this:
#
#     {
#       id: 'lib/parser.coffee',
#
#       htmlFile: 'lib/parser.html',
#       sourceFile: 'lib/parser.coffee',
#
#       baseHtmlFile: 'parser.html',
#       baseSourceFile: 'parser.coffee',
#
#       extension: 'coffee',
#
#       page: "Foobar",
#
#       sections: [ Section, ... ]
#       headings: [ Heading, ... ]
#     }
#
# The `id` field is the `sourceFile`.
#
# It's built with `File.create`:
#
#     File.create 'lib/parser.js.coffee', false, (file) ->
#       console.log file
#       # `file` is a File object

datastruct = require '../../datastruct'
Section = require './section'
Heading = require './heading'

class File
  datastruct this

  @property
    'id':             default: null
    'htmlFile':       default: null
    'sourceFile':     default: null
    'extension':      default: null
    'baseSourceFile': default: null
    'baseHtmlFile':   default: null
    'pageID':         default: null  # Associated page ID
    'sections':       default: [], subtype: Section
    'headings':       default: [], subtype: Heading

  constructor: (options, @project) ->
    @set options

  @property 'page', hidden: true, get: ->
    @project.pages[@pageID]

  # ### node
  # Returns the associated `Filetree` node.
  @property 'node', hidden: true, get: ->
    node = @project.fileTree
    @segments.forEach (segment) -> node = node?.paths[segment]
    node

  # ### parentNode
  # Returns the parent file node.
  @property 'parentNode', hidden: true, get: ->
    @node.parent

module.exports = File
