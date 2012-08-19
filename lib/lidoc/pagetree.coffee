# # Lidoc: Pagetree

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
  constructor: (options={}) ->
    @id    = options.id ? ''
    @name  = options.name ? ''
    @page  = null
    @paths = {}

  # ### buildFrom(pages)
  # Builds a tree from a given project pages index `pages`.
  buildFrom: (pages) ->
    for i, page of pages
      @addPage page, page.segments

    this

  # ### setPage
  # Absorbs properties of given page `page`.
  setPage: (page) ->
    @name = page.name
    @page = page.id

  addPage: (page, segments) ->
    @paths[segments[0]] ?= new Pagetree(id: segments[0])

    #- If it's a child: add the page as a child.
    if segments.length is 1
      @paths[segments[0]].setPage page

    #- Else, make the parent.
    else
      @paths[segments[0]].name = segments[0]
      @paths[segments[0]].addPage page, segments.slice(1)


module.exports = Pagetree
