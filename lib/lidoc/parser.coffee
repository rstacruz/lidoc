# # Lidoc.Parser

# Handles parsing of documents and outputs them into a general-purpose JSON.

fs = require 'fs'
path = require 'path'
{getLanguage} = require './languages'
{slugify, changeExtension} = require './helpers'
{Section, File, Project, Page, Heading} = require './structs'

# ### parse()

# Parses a project.
#
# Returns a big JSON structured output (see `Project` under {Structs}).
#
# It takes an options hash with the option `files`.
#
#     parse files: ['a.js','b.js', 'c.js'], (project) ->
#
parse = (options, callback) ->
  files = options.files
  output = new Project
  i = 0

  # Parse each of the given files using `File.create()`.
  console.warn "Parsing:"  unless options.quiet
  files.forEach (fname, ii) ->

    #- Reserve the slot so to preserve proper order.
    output.files[fname] = null

    #- The first file will be the index file.
    isIndex = ii is 0

    #- Parse and highlight the file...
    File.create fname, isIndex, (file) ->
      i += 1
      output.files[file.sourceFile] = file
      console.warn "  < (#{i}/#{files.length}) #{file.sourceFile}"  unless options.quiet

      #- and when it's done...
      if i is files.length
        #- Generate a `pages` index...
        output.pages = Page.createAll(output.files)

        #- and invoke the `callback` function with the final output.
        callback output

# ## Private API

# Okay, these are mostly private stuff.

# ### File.create()

# Parses a given filename `source`.
# When it's done, invokes `callback` with a new `File` instance.
#
File.create = (source, isIndex=false, callback) ->
  code = fs.readFileSync(source).toString()
  htmlFile = (if isIndex then 'index.html' else changeExtension(source, '.html'))

  # Parse the code into blocks to be sectionized using `parseCode`.
  file = new File
    htmlFile: htmlFile
    sections: parseCode(source, code)
    sourceFile: source
    baseHtmlFile: path.basename(htmlFile)
    baseSourceFile: path.basename(source)
    extension: path.extname(source).substr(1)
    headings: []

  file.highlight ->
    #- Inject headings into each section.
    file.addHeadings()

    #- Collect sub headings into `headings`.
    #  Also keep the first `<h1>` and place it onto `mainHeading`.
    file.sections.forEach (section) ->
      section.headings.forEach (heading) ->
        file.mainHeading = heading  if heading.level is 1
        file.headings.push heading

    #- Invoke the callback.
    callback file

# ### File::highlight()

# Adds to HTML fields to it `docsHtml` and `codeHtml` to all sections.
#
# Highlights a single chunk of CoffeeScript code, using **Pygments** over stdio,
# and runs the text of its corresponding comment through **Markdown**, using
# [Showdown.js](http://attacklab.net/showdown/).
#
# We process the entire file in a single call to Pygments *[1]* by inserting
# little marker comments between each section *[1]* and then splitting the
# result string wherever our markers occur *[2]*.

File::highlight = (callback) ->
  #- The start and end of each Pygments highlight block.
  highlightStart = '<div class="highlight"><pre>'
  highlightEnd   = '</pre></div>'

  showdown = require('../../vendor/showdown').Showdown
  {spawn} = require 'child_process'

  language = getLanguage @sourceFile
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

  pygments.on 'exit', =>
    output = output.replace(highlightStart, '').replace(highlightEnd, '')
    fragments = output.split language.dividerHtml # [2]
    for section, i in @sections
      section.codeHtml = if fragments[i]
        highlightStart + fragments[i] + highlightEnd
      else
        ""
      section.docsHtml = showdown.makeHtml section.docsText

    callback @sections

  if pygments.stdin.writable
    text = (section.codeText for section in @sections)
    pygments.stdin.write text.join language.dividerText # [1]
    pygments.stdin.end()

# ### File::addHeadings()

# Takes a `sections` array of **section** objects and adds *heading* and
# *anchor* so that they look like:
#
#     {
#       docsText: ...
#       docsHtml: ...
#       codeText: ...
#       codeHtml: ...
#       anchor: '...'
#       headings: [
#         { level: 3, title: 'Expanding sections', anchor: 'expanding-sections' },
#         ...
#       ]
#     }
#
File::addHeadings = ->
  @sections.forEach (section, i) =>
    section.buildHeadings @htmlFile, i

# ### parseCode()

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
parseCode = (source, code) ->
  lines    = code.split '\n'
  sections = []
  language = getLanguage source
  hasCode  = docsText = codeText = ''

  save = (docsText, codeText) ->
    sections.push new Section
      docsText: docsText
      codeText: codeText

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

# ### Page.createAll()

# Collects the `<h1>` headings in the given files and returns a list of them.
#
# `files` a key/value object of many `File` instances.
#
# Returns an key/value object of `Page` instances, with keys being the Page
# titles.
#
Page.createAll = (files) ->
  pages = {}
  for fname, file of files

    current = null
    file.headings.forEach (heading) ->
      if heading.level is 1
        current = "#{heading.title}"

        #- If there is already a page with the same title, append the filename
        #  in there.
        if pages[current]
          current = "#{heading.title} (#{fname})"

        pages[current] = new Page
          title: heading.title
          htmlFile: fname
          headings: []

      else
        if pages[current]?
          pages[current].headings.push heading

  pages

# ### Section::buildHeadings()

# Sets `headings` and `anchor` for the section. The assumption is that this is
# being done after the sections were pygmentized.
#
Section::buildHeadings = (htmlFile, i) ->
  @headings = []

  m = @docsHtml.match /<h[1-6]>.*?<\/h[1-6]>/ig
  if m?
    m.forEach (match) =>
      mm = match.match /<h([1-6])>(.*?)<\/h[1-6]>/i
      @anchor = slugify(mm[2])
      level = parseInt(mm[1])
      if level <= 3
        @headings.push new Heading
          level: level
          title: mm[2]
          anchor: slugify(mm[2])
          htmlFile: htmlFile

  else
    @anchor = "section-#{i}"

module.exports = {parse}
