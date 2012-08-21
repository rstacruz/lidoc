# # Lidoc
# This is the main entry point for the entire library.
#
#     Lidoc = require('lidoc')
#
# From here, you can do:
#
#     Lidoc.parse files: [...], (project) ->
#       Lidoc.build project, output: 'docs', ->
#         console.log "Done!"
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

  # ## Classes
  # See their respective files for more info.

  FileNode: require('./lidoc/models/file_node')
  PageNode: require('./lidoc/models/page_node')
  Page: require('./lidoc/models/page')
  File: require('./lidoc/models/file')
  Section: require('./lidoc/models/section')
  Project: require('./lidoc/models/project')
  Heading: require('./lidoc/models/heading')
