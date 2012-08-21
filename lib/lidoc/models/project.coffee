# # Models: Project

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

Page = require './page'
File = require './file'
Filetree = require './filetree'
Pagetree = require './pagetree'

datastruct = require '../../datastruct'

class Project
  datastruct this

  @property
    'pages':    default: {}, subtype: Page
    'files':    default: {}, subtype: File
    'fileTree': default: {}, type: Filetree
    'pageTree': default: {}, type: Pagetree

  constructor: (options) ->
    @set options

module.exports = Project
