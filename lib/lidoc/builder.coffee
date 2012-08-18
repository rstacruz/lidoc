# # Lidoc.Builder

fs = require 'fs'
path = require 'path'
mkdirp = require 'mkdirp'
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
  console.log "Writing assets:"

  #- Fetch the default CSS file.
  css = getResource('default.css')
  outFile = path.join(options.output, 'style.css')

  #- Inject extra CSS needed
  #  (TODO)

  #- Write it
  fs.writeFileSync(outFile, css)
  console.log "  > #{outFile}"

getFileDepth = (filepath) ->
  path = require 'path'
  filepath.match(new RegExp(path.sep, 'g')).length

strRepeat = (str, count) ->
  output = ""
  for i in [0..count]
    output += str
  output

# ### writeFiles()

# Writes HTML files to the output path.

writeFiles = (project, options) ->
  console.log "Writing:"

  tpl = template(getResource('default.html'))

  #- Write each of the HTML files.
  for fname, file of project.files
    outFile = path.join(options.output, file.htmlFile)
    depth = getFileDepth(file.htmlFile)

    output = tpl
      title: file.mainHeading?.title
      sections: file.sections

      root: strRepeat('../', depth-1)  # For relative paths

      file: file
      project: project
      depth: depth
      css: strRepeat('../', depth-1) + 'style.css'

    mkdirp path.dirname(outFile)
    console.log "  > #{outFile}"
    fs.writeFileSync outFile, output

module.exports = {build}
