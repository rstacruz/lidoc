# # Lidoc.Languages

{getResource} = require './helpers'
path = require 'path'

# ### languages

# A dict object of languages.
languages = JSON.parse getResource 'languages.json'

# Build out the appropriate matchers and delimiters for each language.
for ext, l of languages

  #- Ignore [hashbangs](http://en.wikipedia.org/wiki/Shebang_(Unix\))
  #  and interpolations...
  l.commentFilter = /(^#![/]|^\s*#\{)/

  #- Does the line begin with a comment?
  if l.symbol is ""
    l.commentMatcher = ///^///
    l.commentFilter = /^$/
  else
    l.commentMatcher = ///^\s*#{l.symbol}\s?///

  #- The dividing token we feed into Pygments, to delimit the boundaries between
  #  sections.
  l.dividerText = "\n#{l.symbol}DIVIDER\n"

  #- The mirror of `dividerText` that we expect Pygments to return. We can split
  #  on this to recover the original sections.
  #  Note: the class is "c" for Python and "c1" for the other languages
  l.dividerHtml = ///\n*<span\sclass="c1?">#{l.symbol}DIVIDER<\/span>\n*///

# ### getLanguage()

# Get the current language we're documenting, based on the extension of the
# filename `source`.
#
#     getLanguage(".py")
#     #=> {name: "Python", commentMatcher: "..", commentFilter: "...", }
#
getLanguage = (source) -> languages[path.extname(source)]

# ...
module.exports = {languages, getLanguage}
