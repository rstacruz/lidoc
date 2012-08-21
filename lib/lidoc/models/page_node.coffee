# # Models: PageNode

datastruct = require '../../datastruct'

# An index for pages.
#
# Each node represents either a true page or an inferred page (a folder, if you
# will). This means that each PageNode may or may not have a Page associated
# wiht it.
#
# Accessed via `project.pageTree`. See {Project}.

# ### Example

#     project.pageTree == {
#       title: '',
#       page: null,
#       paths: {
#         'Getting started': {
#           name: 'Getting started',
#           page: 'getting_started.html' } } }

# ### Using the PageNode

# Getting a pagenode:
#
#     // The `pageTree` itself is a node
#     node = project.pageTree
#
#     // Or you can traverse along like so
#     node = project.pageTree.paths['Guides']
#
# Using it:
#
#     node.title   //=> "Getting started"
#     node.paths   //=> { ... }
#
# Getting a page:
#
#     page = project.pageTree.paths['Guides'].page
#
#     page.sourceFile  //=> "guides.md"
#
# Traversing:
#
#     project.pageTree.paths['Guides'].paths['Getting started']

class PageNode
  datastruct this

  @property
    'id':       default: null
    'title':    default: null
    'pageID':   default: null
    'paths':    default: {}, subtype: PageNode

  constructor: (options={}, parent) ->
    if parent?.constructor is PageNode
      @parent  = parent
      @project = parent.project
    else if parent?.files # Project
      @project = parent

    @set options

  # ## Properties

  # ### page
  # Returns the `Page` instance associated with the node.
  @property 'page', hidden: true, get: ->
    @project.pages[@pageID]

  # ### file
  # Returns the associated `File`.
  @property 'file', hidden: true, get: ->
    @page?.file

  # ### breadcrumbs
  # Returns an array of `PageNode`s, starting from the root, to this one.
  @property 'breadcrumbs', hidden: true, get: ->
    if @parent
      @parent.breadcrumbs.concat [this]
    else
      [this]

  # ### ancestors
  # Returns an array of `PageNode`s, starting from the root, to this node's
  # parent.
  @property 'ancestors', hidden: true, get: ->
    crumbs = @breadcrumbs
    crumbs.pop()
    crumbs

  # ### hasChildren
  # Returns true if it has children.
  @property 'hasChildren', hidden: true, get: ->
    Object.keys(@paths).length isnt 0

  # ### root
  # Returns the root node.
  @property 'root', hidden: true, get: ->
    @project.pageTree

  # ### reference
  # Go through each of the breadcrumbs and find one with children.
  @property 'reference', hidden: true, get: ->
    crumbs = @breadcrumbs
    output = @root

    for i in [0..crumbs.length-1]
      output = crumbs[i]  if crumbs[i].hasChildren

    output

  # ## Methods

  # ### buildFrom(project)
  # Builds a tree from a given project.
  buildFrom: (@project) ->
    for i, page of project.pages
      @addPage page, page.segments, project

    this

  # ### setPage
  # Absorbs properties of given page `page`.
  setPage: (page) ->
    @title   = page.title
    @pageID  = page.id

  addPage: (page, segments, project) ->
    file = project.files[page.file]

    #- If it's a grandchild, make the intermediate parents first.
    if segments.length > 1
      @paths[segments[0]] ?= new PageNode(id: segments[0], this)
      @paths[segments[0]].title = segments[0]
      @paths[segments[0]].addPage page, segments.slice(1), project

    #- The first file will be the root of all.
    #  (It's Parser's responsibility to set segments to 0)
    else if segments.length is 0
      @setPage page

    #- If it's a child: add the page as a child.
    else
      @paths[segments[0]] ?= new PageNode(id: segments[0], this)
      @paths[segments[0]].setPage page

module.exports = PageNode
