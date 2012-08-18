# # Lidoc

# This is the main entry point for the entire library.
#
#     Lidoc = require('lidoc')
#
# From here, you can do:
#
#     Lidoc.parse files: [...], (project) ->
#       Lidoc.build(project, output: 'docs')
#
# See {Builder.build()} and {Parser.parse()} for more info.

fs = require 'fs'
path = require 'path'

pkg = JSON.parse fs.readFileSync(path.join(__dirname, '..', 'package.json'), 'utf-8')

module.exports =

  # ### parse()

  # Parses a source tree and outputs JSON. See {Parser.parse()}.
  parse: require('./lidoc/parser').parse

  # ### build()

  # Builds HTML output from a project tree built by `parse()`. See
  # {Builder.build()}.
  build: require('./lidoc/builder').build

  # ### version

  # The **Lidoc** version.
  version: pkg.version
