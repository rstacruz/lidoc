# # Lidoc.Structs

# Structures. You can access these from {Lidoc} itself:
#
#     Lidoc = require('lidoc')
#
#     Lidoc.Page
#     Lidoc.Project

# ## Struct

# Basic superclass of all structs.
#
class Struct
  constructor: (source) ->
    for key, value of source
      @[key] = value

# ## Project

# Holds indexes of `Page`s and `File`s.
#
# This is also the output of `parse()`.
#
#     {
#       pages: {
#         'Parser': { Page },
#         'Helpers': { Page },
#         ...
#       },
#       files: {
#         'index.html': { File },
#         'lib/parser.html': { File },
#         '...'
#       }
#     }
#
class Project extends Struct
  constructor: ->
    @pages = {}
    @files = {}

  getFileTree: ->
    Filetree = require './filetree'
    (new Filetree).buildFrom @files

# ## Page

# Extracted from `<h1>`s of files. Looks like this:
#
#     {
#       title: "Helpers",
#       htmlFile: "lib/helpers.html",
#       headings: [ Heading, Heading, ... ]
#     }
#
class Page extends Struct
  constructor: ->
    @title    = null
    @htmlFile = null
    @headings = []
    super

# ## Heading

# A h1, h2 or h3 heading. Looks like:
#
#     {
#       level: 2,
#       title: "parse()',
#       anchor: "parse",
#       htmlFile: "lib/parser.html"
#     }
#
class Heading extends Struct
  constructor: ->
    @level    = null
    @title    = null
    @anchor   = null
    @htmlFile = null
    super

# ## File

# Represents a source file and it's generated HTML file. Stores code/docs in
# `sections`. Looks like this:
#
#     {
#       htmlFile: 'lib/parser.js.html',
#       sourceName: 'lib/parser.js.coffee',
#       extension: 'coffee',
#       sections: [ Section, ... ]
#       headings: [ Heading, ... ]
#     }
#
# It's built with `File.create`:
#
#     File.create 'lib/parser.js.coffee', false, (file) ->
#       console.log file
#       # `file` is a File object
#
class File extends Struct
  constructor: ->
    @htmlFile   = null
    @sourceName = null
    @extension  = null
    @sections   = []
    @headings   = []
    super

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
class Section extends Struct
  constructor: ->
    @docsText = null
    @codeText = null
    @docsHtml = null
    @codeHtml = null
    @anchor = null
    super

module.exports = {Section, File, Project, Page, Heading}
