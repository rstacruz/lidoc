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
    'file':     default: null
    'segments': default: []
    'headings': default: [], subtype: Heading

  constructor: (options, @project) ->
    @set options

module.exports = Page
