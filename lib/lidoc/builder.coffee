# # Lidoc.Builder
# Builds HTML/CSS files.

fs = require 'fs'
path = require 'path'
async = require 'async'
mkdirp = require('mkdirp').sync
{template, getResource, getFileDepth, strRepeat} = require './helpers'

# ### build()
# Builds the HTML/CSS files in the path in `options.output`. The argument
# `project` is something that comes from {parse()}.
#
#     options = {
#       files: ['a.js', 'b.js'],
#       output: 'docs'
#     };
#
#     project = Lidoc.parse(options);
#     Lidoc.build(project, options, callback);
#
# This is accessible via {Lidoc#build()}.
#
build = (project, options, callback) ->
  #- Build the output directory.
  mkdirp options.output

  async.parallel [
    (cb) -> writeCSS project, options, cb
    (cb) -> writeFiles project, options, cb
    (cb) -> writeAssets project, options, cb
  ], callback

compileCSS = (css, callback) ->
  stylus = require 'stylus'
  nib = require 'nib'

  stylus(css).use(nib()).render (err, actual) ->
    if err?
      console.warn ""
      console.warn "Stylus error (#{err.name}):"
      console.warn err.message

    callback actual

# ### writeCSS()
# Writes CSS files to the output path.

writeCSS = (project, options, callback) ->
  #- Fetch the default CSS file.
  css = if options.css?
    fs.readFileSync(options.css, 'utf-8')
  else
    getResource('default.css')

  #- Render and write it
  outFile = path.join(options.output, 'style.css')

  compileCSS css, (data) ->
    fs.writeFile outFile, data, ->
      console.warn "  > #{outFile}"  unless options.quiet
      callback null, true

# ### writeAssets()
# Takes care of other assets, supposedly...

writeAssets = (project, options, callback) ->
  contents = getResource('script.js')
  outFile = path.join(options.output, 'script.js')

  fs.writeFile outFile, contents, ->
    console.warn "  > #{outFile}"  unless options.quiet
    callback null, true

getSourceUrl = (file, options) ->
  if options.github? and options.gitBranch?
    "https://github.com/#{options.github}/blob/#{options.gitBranch}/#{file.sourceFile}"
  else
    null

treeFind = (pageTree, page) ->
  current = pageTree
  page.segments.forEach (segment) ->
    current = current?.paths?[segment]
  current

# ### writeFiles()
# Writes HTML files to the output path.

writeFiles = (project, options, callback) ->
  tpl = template(getResource('default.html'))
  calls = []

  #- Write each of the HTML files.
  for fname, file of project.files
    outFile = path.join(options.output, file.htmlFile)
    depth   = getFileDepth(file.htmlFile)
    root    = strRepeat('../', depth)

    #- A file may or may not have a page (say if it has no H1).
    page    = file.page

    output = tpl
      title:       page?.title ? file.baseHtmlFile
      root:        root                         # Prefix for relative paths
      css:         "#{root}style.css"           # URL path to CSS file
      sourceUrl:   getSourceUrl(file, options)  # Github path
      project:     project
      depth:       depth
      options:     options
      sections:    file.sections
      reference:   page?.node.reference
      current:
        file: file
        page: page

    #- Queue up the mkdir/writeFile calls.
    calls.push do (outFile, output) ->
      (callback) ->
        mkdirp path.dirname(outFile)
        fs.writeFile outFile, output, ->
          console.warn "  > #{outFile}"  unless options.quiet
          callback null, outFile

  #- Invoke the queued up the write functions.
  async.parallel calls, callback

module.exports = {build}
