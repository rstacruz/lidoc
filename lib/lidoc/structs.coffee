# # Lidoc.Structs

# Structures. You can access these from {Lidoc} itself:
#
#     Lidoc = require('lidoc')
#
#     Lidoc.Page
#     Lidoc.Project

Filetree = require './filetree'
Pagetree = require './pagetree'
datastruct = require '../datastruct'

# ## Project

# Holds indexes of `Page`s and `File`s.
#
# This is also the output of `parse()`.
#
#     {
#       pages: {
#         'App': { Page },
#         'App: Builder': { Page },
#         ...
#       },
#       files: {
#         'hi.html': { File },
#         'hello.html': { File },
#         ...
#       },
#       fileTree: { Filetree }
#       pageTree: { Pagetree }
#     }
#
# The keys of `pages` and `files` are their `id` fields.
#
class Project
  datastruct this

  @property
    'pages':    default: {}, subtype: Page
    'files':    default: {}, subtype: File
    'fileTree': default: {}, subtype: Filetree
    'pageTree': default: {}, subtype: Pagetree

  constructor: (options) ->
    @set options

# ## Page

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
#
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

# ## Heading

# A h1, h2 or h3 heading. Looks like:
#
#     {
#       title: "parse()",
#       anchor: "parse",
#       level: 2,
#       file: "lib/parser.html"
#     }
#
class Heading
  datastruct this

  @property
    'title':   default: null
    'anchor':  default: null
    'level':   default: null
    'file':    default: null

  constructor: (options, @parent) ->
    @project = @parent?.project
    @set options

# ## File

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
#
class File
  datastruct this

  @property
    'id':             default: null
    'htmlFile':       default: null
    'sourceFile':     default: null
    'extension':      default: null
    'baseSourceFile': default: null
    'baseHtmlFile':   default: null
    'page':           default: null  # Associated page ID
    'sections':       default: [], subtype: Section
    'headings':       default: [], subtype: Heading

  constructor: (options, @project) ->
    @set options

# ## Section

# Represents a comment/code block pair.
#
#     {
#       docsText: '# Parsing code ...'
#       docsHtml: '<h3>Parsing code</h3> ...'
#
#       codeText: 'def parsingCode() ...'
#       codeHtml: '...'
#
#       anchor: 'Parsing-code'
#     }
#
class Section
  datastruct this

  @property
    'docsText': default: null
    'codeText': default: null
    'docsHtml': default: null
    'codeHtml': default: null
    'anchor':   default: null

  constructor: (options, @file) ->
    @project = @file?.project
    @set options

module.exports = {Section, File, Project, Page, Heading}
