# # Lidoc.Helpers
# Hello.

fs = require 'fs'
path = require 'path'

# ### getResource()
# Read resource file `name` and return its content.
#
#     getResource('languages.json')
#
getResource = (name) ->
  fullPath = path.join __dirname, '..', '..', 'resources', name
  fs.readFileSync(fullPath).toString()

# ### template()
# Micro-templating, originally by John Resig, borrowed by way of
# [Underscore.js](http://documentcloud.github.com/underscore/).
#
template = (str) ->
  new Function 'obj',
    'var p=[],print=function(){p.push.apply(p,arguments);};' +
    'with(obj){p.push(\'' +
    str.replace(/[\r\t]/g, " ")
       .replace(/'(?=[^<]*%>)/g,"\t")
       .split("'").join("\\'")
       .split("\t").join("'")
       .replace(/<%=(.+?)%>\n?/g, "',$1,'")
       .split('<%').join("');")
       .split(/%>\n?/).join("p.push('")
       .split("\n").join("\\n") +
       "');}return p.join('');"

# ### slugify()
# Takes a given string `str` and normalizes it to be an alpha-numeric string.
#
#     slugify("50% off")  #=> "50-off"
#
slugify = (str, space='-') ->
  str.replace(/[^A-Za-z0-9]+/g, ' ').trim().replace(/\ +/g, space)

# ### changeExtension()
# Replaces the extension of `filename` to `ext`.
#
#     changeExtension("parser.js", ".html")
#     #=> "parser.html"
#
changeExtension = (filename, ext) ->
  filename.replace(/(\.[^\.]+)?$/, ext)

# ### getFileDepth()

getFileDepth = (filepath) ->
  path = require 'path'
  m = filepath.match(new RegExp(path.sep, 'g'))
  if m? then m.length else 0

# ### strRepeat()
# Repeats a given string `str` up to `count` times.

strRepeat = (str, count=1) ->
  return ""  if count <= 0
  output = ""
  for i in [1..count]
    output += str
  output

module.exports =
  {getResource, template, slugify, changeExtension, strRepeat,
  getFileDepth}
