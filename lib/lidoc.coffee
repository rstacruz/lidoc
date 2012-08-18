fs = require 'fs'
{getLanguage} = require './lidoc/languages'

# ### parse()

# Given a string of source code `code` with filename `source`, parse out each
# comment and the code that follows it, and create an individual **section**
# for it.  Sections take the form:
#
#     {
#       docsText: ...
#       codeText: ...
#     }
#
# Returns an array of sections.
#
parse = (source, code) ->
  lines    = code.split '\n'
  sections = []
  language = getLanguage source
  hasCode  = docsText = codeText = ''

  save = (docsText, codeText) ->
    sections.push {docsText, codeText}

  for line in lines
    if line.match(language.commentMatcher) and not line.match(language.commentFilter)
      if hasCode
        save docsText, codeText
        hasCode = docsText = codeText = ''
      docsText += line.replace(language.commentMatcher, '') + '\n'
    else
      hasCode = yes
      codeText += line + '\n'
  save docsText, codeText
  sections

# The start of each Pygments highlight block.
highlightStart = '<div class="highlight"><pre>'

# The end of each Pygments highlight block.
highlightEnd   = '</pre></div>'

# ### highlight()

# Converts `sections` given by parse() to HTML.
#
#     {
#       docsText: ...
#       docsHtml: ...
#       codeText: ...
#       codeHtml: ...
#     }
#
# Highlights a single chunk of CoffeeScript code, using **Pygments** over stdio,
# and runs the text of its corresponding comment through **Markdown**, using
# [Showdown.js](http://attacklab.net/showdown/).
#
# We process the entire file in a single call to Pygments by inserting little
# marker comments between each section and then splitting the result string
# wherever our markers occur.

highlight = (source, sections, callback) ->
  showdown = require('./../vendor/showdown').Showdown
  {spawn} = require 'child_process'

  language = getLanguage source
  pygments = spawn 'pygmentize', [
    '-l', language.name,
    '-f', 'html',
    '-O', 'encoding=utf-8,tabsize=2'
  ]
  output   = ''

  pygments.stderr.on 'data',  (error)  ->
    console.error error.toString() if error

  pygments.stdin.on 'error',  (error)  ->
    console.error 'Could not use Pygments to highlight the source.'
    process.exit 1

  pygments.stdout.on 'data', (result) ->
    output += result if result

  pygments.on 'exit', ->
    output = output.replace(highlightStart, '').replace(highlightEnd, '')
    fragments = output.split language.dividerHtml
    for section, i in sections
      section.codeHtml = highlightStart + fragments[i] + highlightEnd
      section.docsHtml = showdown.makeHtml section.docsText

    callback sections

  if pygments.stdin.writable
    text = (section.codeText for section in sections)
    pygments.stdin.write text.join language.dividerText
    pygments.stdin.end()

# ### parseFile()

# Parses a given filename `source`.
# When it's done, invokes `callback` with the completed sections.
#
parseFile = (source, callback) ->
  code = fs.readFileSync(source).toString()
  sections = parse(source, code)
  highlight source, sections, ->
    callback
      sections: sections

parseFile "lib/lidoc.coffee", (s) ->
  console.log s

