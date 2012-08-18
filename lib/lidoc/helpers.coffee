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
    str.replace(/[\r\t\n]/g, " ")
       .replace(/'(?=[^<]*%>)/g,"\t")
       .split("'").join("\\'")
       .split("\t").join("'")
       .replace(/<%=(.+?)%>/g, "',$1,'")
       .split('<%').join("');")
       .split('%>').join("p.push('") +
       "');}return p.join('');"

# ### slugify()

# Takes a given string `str` and normalizes it to be an alpha-numeric string.
#
#     slugify("50% off")  #=> "50-off"
#
slugify = (str, space='-') ->
  str.replace(/[^A-Za-z0-9]+/g, ' ').trim().replace(/\ +/, space)

module.exports = {getResource, template, slugify}
