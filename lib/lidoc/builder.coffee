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

writeCSS = (project, options) ->
  console.warn "Writing assets:"  unless options.quiet

  #- Fetch the default CSS file.
  css = if options.css?
    fs.readFileSync(options.css, 'utf-8')
  else
    getResource('default.css')

  #- Render and write it
  outFile = path.join(options.output, 'style.css')

  compileCSS css, (data) ->
    fs.writeFileSync(outFile, data)
    console.warn "  > #{outFile}"  unless options.quiet

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
  console.warn "  > #{outFile}"  unless options.quiet
  fs.writeFileSync(outFile, contents)

# ### writeFiles()

# Writes HTML files to the output path.

writeFiles = (project, options) ->
  console.warn "Writing:"  unless options.quiet

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
      current:
        file: file
        page: {}
      file: file
      project: project
      depth: depth

    mkdirp path.dirname(outFile)
    console.warn "  > #{outFile}"  unless options.quiet
    fs.writeFileSync outFile, output

module.exports = {build}
