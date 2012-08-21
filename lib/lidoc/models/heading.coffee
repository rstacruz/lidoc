# # Models: Heading
# A h1, h2 or h3 heading. Looks like:
#
#     {
#       title: "parse()",
#       anchor: "parse",
#       level: 2,
#       file: "lib/parser.html"
#     }

datastruct = require '../../datastruct'

class Heading
  datastruct this

  @property
    'title':   default: null
    'anchor':  default: null
    'level':   default: null
    'fileID':  default: null

  constructor: (options, @parent) ->
    @project = @parent?.project
    @set options

module.exports = Heading
