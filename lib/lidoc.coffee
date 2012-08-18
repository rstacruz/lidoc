# # Lidoc

# This is the main entry point for the entire library.
#
#     Lidoc = require('lidoc')

# From here, you can do:
#
#     project = Lidoc.parse(files: [...])
#
#     Lidoc.build(project, output: 'docs')

# See {Builder.build()} and {Parser.parse()} for more info.

{parse} = require './lidoc/parser'

module.exports =
  build: require('./lidoc/builder').build
  parse: require('./lidoc/parser').parse
