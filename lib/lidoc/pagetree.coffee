# # Lidoc: Pagetree

datastruct = require '../datastruct'

# An index for pages.
#
# Accessed via `project.pageTree`. See {Project}.

# ### Example

#     project.pageTree ==
#       name: ''
#       page: null
#       paths:
#         'Getting started':
#           name: 'Getting started'
#           page: 'getting_started.html'

# ### Using the Pagetree

# Getting a file:
#
#     fileID = project.pageTree.paths['Guides'].file
#     file = project.file[fileID]
#
# Traversing:
#
#     project.pageTree.paths['Guides'].paths['Getting started']

class Pagetree
  datastruct this

  @property
    'id':    default: null
    'title': default: null
    'page':  default: null
    'paths': default: {}, subtype: Pagetree

  constructor: (options={}, parent) ->
    if parent?.project
      @parent  = parent
      @project = parent.project
    else if parent?.files
      @project = parent

    @set options

  # ### buildFrom(project)
  # Builds a tree from a given project.
  buildFrom: (project) ->
    for i, page of project.pages
      @addPage page, page.segments, project

    this

  # ### setPage
  # Absorbs properties of given page `page`.
  setPage: (page) ->
    @title = page.title
    @page  = page.id

  addPage: (page, segments, project) ->
    file = project.files[page.file]

    #- If it's a grandchild, make the intermediate parents first.
    if segments.length > 1
      @paths[segments[0]] ?= new Pagetree(id: segments[0])
      @paths[segments[0]].title = segments[0]
      @paths[segments[0]].addPage page, segments.slice(1), project

    #- The first file will be the root of all.
    #  (It's Parser's responsibility to set segments to 0)
    else if segments.length is 0
      @setPage page

    #- If it's a child: add the page as a child.
    else
      @paths[segments[0]] ?= new Pagetree(id: segments[0])
      @paths[segments[0]].setPage page

module.exports = Pagetree
