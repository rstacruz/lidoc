# # Lidoc.Languages

{getResource} = require './helpers'
path = require 'path'

# ### languages
# A dict object of languages.

languages =
  ".coffee":  {name: "coffee-script", symbol: "#"}
  ".rb":      {name: "ruby", symbol: "#"}
  ".py":      {name: "python", symbol: "#"}
  ".feature": {name: "gherkin", symbol: "#"}
  ".yaml":    {name: "yaml", symbol: "#"}
  ".tex":     {name: "tex", symbol: "%"}
  ".latex":   {name: "tex", symbol: "%"}
  ".js":      {name: "javascript", symbol: "//"}
  ".c":       {name: "c", symbol: "//"}
  ".h":       {name: "c", symbol: "//"}
  ".cpp":     {name: "cpp", symbol: "//"}
  ".php":     {name: "php", symbol: "//"}
  ".hs":      {name: "haskell", symbol: "--"}
  ".erl":     {name: "erlang", symbol: "%"}
  ".hrl":     {name: "erlang", symbol: "%"}
  ".md":      {name: "markdown", symbol: "", "textOnly": true}

# Build out the appropriate matchers and delimiters for each language.
for ext, l of languages

  #- Ignore [hashbangs](http://en.wikipedia.org/wiki/Shebang_(Unix\))
  #  and interpolations...
  l.commentFilter = /(^#![/]|^\s*#\{)/

  #- Does the line begin with a comment?
  if l.textOnly
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

getLanguage = (source) -> languages[path.extname(source)]

# ...
module.exports = {languages, getLanguage}
