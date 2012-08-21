# # Models: Section

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
datastruct = require '../../datastruct'

class Section
  datastruct this

  @property
    'docsText': default: null
    'codeText': default: null
    'docsHtml': default: null
    'codeHtml': default: null
    'anchor':   default: null
    'headings': default: []

  constructor: (options, @file) ->
    @project = @file?.project
    @set options

module.exports = Section
