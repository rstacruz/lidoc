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

  # ## Classes

  # ### Filetree
  Filetree: require('./lidoc/filetree').Filetree

  # ## Structures

  # ### Page
  # ### File
  # ### Section
  # ### Project
  # ### Heading
  # Structures. See {Structs} for more info on each.
  Page: require('./lidoc/structs').Page
  File: require('./lidoc/structs').File
  Section: require('./lidoc/structs').Section
  Project: require('./lidoc/structs').Project
  Heading: require('./lidoc/structs').Heading
