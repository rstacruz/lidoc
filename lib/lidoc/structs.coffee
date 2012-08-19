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
#     }
#
class Project extends Struct
  constructor: ->
    @pages = {}
    @files = {}
    @fileTree = {}
    super

# ## Page

# Extracted from `<h1>`s of files. Looks like this:
#
#     {
#       title: "Helpers",
#       file: "lib/helpers.html",
#       headings: [ Heading, Heading, ... ]
#     }
#
class Page extends Struct
  constructor: ->
    @id       = null
    @title    = null
    @file     = null
    @headings = []
    super

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
class Heading extends Struct
  constructor: ->
    @title  = null
    @anchor = null
    @level  = null
    @file   = null
    super

# ## File

# Represents a source file and it's generated HTML file. Stores code/docs in
# `sections`. Looks like this:
#
#     {
#       htmlFile: 'lib/parser.js.html',
#       sourceFile: 'lib/parser.js.coffee',
#
#       baseHtmlFile: 'parser.js.html',
#       baseSourceFile: 'parser.js.coffee',
#
#       extension: 'coffee',
#
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
    @id             = null
    @htmlFile       = null
    @sourceFile     = null
    @extension      = null
    @baseSourceFile = null
    @baseHtmlFile   = null
    @sections       = []
    @headings       = []
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
