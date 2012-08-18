fs = require 'fs'
{getLanguage} = require './lidoc/languages'
{slugify, changeExtension} = require './lidoc/helpers'

# # Lidoc
# yes.

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

# Gets `sections` given by parse(), and adds to HTML fields to it `docsHtml`
# and `codeHtml`.
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
# We process the entire file in a single call to Pygments *[1]* by inserting
# little marker comments between each section *[1]* and then splitting the
# result string wherever our markers occur *[2]*.

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
    fragments = output.split language.dividerHtml # [2]
    for section, i in sections
      section.codeHtml = highlightStart + fragments[i] + highlightEnd
      section.docsHtml = showdown.makeHtml section.docsText

    callback sections

  if pygments.stdin.writable
    text = (section.codeText for section in sections)
    pygments.stdin.write text.join language.dividerText # [1]
    pygments.stdin.end()

# ### addHeadings()

# Takes a `sections` array of **section** objects and adds *heading* so that
# they look like:
#
#     {
#       docsText: ...
#       docsHtml: ...
#       codeText: ...
#       codeHtml: ...
#       heading: [
#         { level: 3, title: 'Expanding sections', anchor: 'expanding-sections' },
#         ...
#       ]
#     }
#
addHeadings = (sections) ->
  sections.forEach (section) ->
    section.headings = []

    m = section.docsHtml.match /<h[1-6]>.*?<\/h[1-6]>/ig
    if m?
      m.forEach (match) ->
        mm = match.match /<h([1-6])>(.*?)<\/h[1-6]>/i
        section.headings.push
          level: parseInt(mm[1])
          title: mm[2]
          anchor: slugify(mm[2])

  sections

# ### parseFile()

# Parses a given filename `source`.
# When it's done, invokes `callback` with the completed sections.
#
# Callback is invoked with a file object that looke like:
#
#     {
#       htmlFile: 'parser.html',
#       sourceFile: 'parser.js',
#       sections: /* see addHeadings() */
#       mainHeading: null or {...},
#       headings: []
#     }
#
parseFile = (source, callback) ->
  code = fs.readFileSync(source).toString()
  sections = parse(source, code)
  highlight source, sections, ->

    # inject headings
    addHeadings sections

    # Collect sub headings.
    headings = []
    mainHeading = null
    sections.forEach (section) ->
      section.headings.forEach (heading) ->
        if heading.level is 1
          mainHeading = heading
        else
          headings.push heading

    callback
      htmlFile: changeExtension(source, '.html')
      sourceFile: source
      mainHeading: mainHeading
      headings: headings
      sections: sections

# ### parseProject()

# Parses a project and returns an output like the one below.
#
# It takes an options hash with the option `files`.
#
#     parseProject files: ['...']
#
#     pages: [
#       {
#         title: "Helpers"
#         file: 'lib/parser.js.html',
#         headings: [ ... ]
#       },
#       ...
#     }
#     files: {
#       'lib/parser.js.html': {
#         htmlName: 'lib/parser.js.html',
#         sourceName: 'lib/parser.js.coffee',
#         sections: [ ... ]
#       }
#     }
#
parseProject = (options, callback) ->
  files = options.files

  output =
    pages: {}
    files: {}

  i = 0

  files.forEach (fname) ->
    parseFile fname, (file) ->
      output.files[file.htmlFile] = file
      i += 1

      # We're done collecting outputs
      if i is files.length
        # Collect pages
        output.pages = getPages(output.files)

        callback output

# `files` is a hash, equivalent to parseProject's `files`.
getPages = (files) ->
  re = []
  for fname, file of files
    if file.mainHeading?
      page = file.mainHeading
      re.push
        title: page.title
        file: fname
        headings: file.headings

  re

options = require 'commander'

options
  .version('0.0.1')
  .option('-o, --output <path>', 'Output path [build]', 'build')
  .parse(process.argv)

options.files = options.args

parseProject options, (output) ->
  console.log JSON.stringify(output, null, 2)

