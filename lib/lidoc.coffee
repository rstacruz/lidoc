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

fs = require 'fs'
path = require 'path'

pkg = JSON.parse fs.readFileSync(path.join(__dirname, '..', 'package.json'), 'utf-8')

module.exports =
  build: require('./lidoc/builder').build
  parse: require('./lidoc/parser').parse
  version: pkg.version
