# # Lidoc.Builder

fs = require 'fs'
path = require 'path'
mkdirp = require('mkdirp').sync
{template, getResource} = require './helpers'

# ### build()

# Builds the HTML/CSS files in the path in `options.output`.
#
#     options = {
#       files: ['a.js', 'b.js'],
#       output: 'docs'
#     };
#
#     project = Lidoc.parse(options);
#     Lidoc.build(project, options);
#
build = (project, options) ->
  #- Build the output directory.
  mkdirp options.output

  writeAssets project, options
  writeFiles project, options

# ### writeAssets()

# Writes CSS files to the output path.

writeAssets = (project, options) ->
  console.warn "Writing assets:"

  #- Fetch the default CSS file.
  css = getResource('default.css')
  outFile = path.join(options.output, 'style.css')

  #- Inject extra CSS needed
  #  (TODO)

  #- Write it
  fs.writeFileSync(outFile, css)
  console.warn "  > #{outFile}"

getFileDepth = (filepath) ->
  path = require 'path'
  m = filepath.match(new RegExp(path.sep, 'g'))
  if m? then m.length else 0

strRepeat = (str, count) ->
  return ""  if count <= 0
  output = ""
  for i in [1..count]
    output += str
  output

# ### writeFiles()

# Writes HTML files to the output path.

writeFiles = (project, options) ->
  console.warn "Writing:"

  tpl = template(getResource('default.html'))

  #- Write each of the HTML files.
  for fname, file of project.files
    outFile = path.join(options.output, file.htmlFile)
    depth = getFileDepth(file.htmlFile)

    output = tpl
      title: file.mainHeading?.title
      sections: file.sections
      #- Prefix for For relative paths.
      root: strRepeat('../', depth)
      #- URL path to CSS file.
      css: strRepeat('../', depth) + 'style.css'
      file: file
      project: project
      depth: depth

    mkdirp path.dirname(outFile)
    console.warn "  > #{outFile}"
    fs.writeFileSync outFile, output

module.exports = {build}
