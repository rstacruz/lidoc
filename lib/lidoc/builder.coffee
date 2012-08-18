# # Lidoc.Builder

# Builds HTML/CSS files.
#
fs = require 'fs'
path = require 'path'
mkdirp = require('mkdirp').sync
{template, getResource} = require './helpers'

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
#     Lidoc.build(project, options);
#
build = (project, options) ->
  #- Build the output directory.
  mkdirp options.output

  writeCSS project, options
  writeAssets project, options
  writeFiles project, options

# ### writeCSS()

# Writes CSS files to the output path.

writeCSS = (project, options) ->
  stylus = require 'stylus'
  nib = require 'nib'

  console.warn "Writing assets:"

  #- Fetch the default CSS file.
  css = getResource('default.css')
  outFile = path.join(options.output, 'style.css')

  #- Inject extra CSS needed
  #  (TODO)

  #- Render and write it
  stylus(css).use(nib()).render (err, actual) ->
    css = actual
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

# ### writeAssets()

# Takes care of other assets, supposedly...

writeAssets = (project, options) ->
  contents = getResource('script.js')
  outFile = path.join(options.output, 'script.js')
  console.warn "  > #{outFile}"
  fs.writeFileSync(outFile, contents)

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
