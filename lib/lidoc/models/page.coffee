# # Models: Page

# Extracted from `<h1>`s of files. Looks like this:
#
#     {
#       id: "Helpers"
#       title: "Helpers",
#       segments: ["Helpers"]
#       file: "lib/helpers.html",
#       headings: [ Heading, Heading, ... ]
#     }
#
# The `id` is usually the full name.
#
#     id: "Guides: Getting started"
#     title: "Getting started"
#     segments: ["Guides", "Getting started"]
#
# In the event of a clash, the `id` will include the filename.
#
#     id: "Lidoc (README.md)"
#     title: "Lidoc"

Heading = require './heading'
datastruct = require '../../datastruct'

class Page
  datastruct this

  @property
    'id':       default: null
    'title':    default: null
    'fileID':   default: null
    'segments': default: []
    'headings': default: [], subtype: Heading

  # ### file
  # Returns the page's associated `File`.
  @property 'file', hidden: true, get: ->
    @project.files[@fileID]

  # ### node
  # Returns the `Pagetree` node.
  @property 'node', hidden: true, get: ->
    node = @project.pageTree
    @segments.forEach (segment) -> node = node?.paths[segment]
    node

  # ### parentNode
  # Returns the parent node.
  @property 'parentNode', hidden: true, get: ->
    @node.parent

  # ### parentPage
  # Returns the parent page.
  @property 'parentPage', hidden: true, get: ->
    @parentNode.page

  constructor: (options, @project) ->
    @set options

module.exports = Page
