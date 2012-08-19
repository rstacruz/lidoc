# # Lidoc.Command

# Lidoc command line tool.

Lidoc = require '../lidoc'
fs = require 'fs'

# ### getOptions()

# The command line parser.

getOptions = ->
  # Bulid the command line parser using `commander`.
  options = require 'commander'
  options
    .version("Lidoc version #{Lidoc.version}")
    .usage("<sourcefile ...> [options]")
    .option('-o, --output <path>', 'Write documentation output into this path')
    .option('-i, --index [file]', 'Write index into file (use stdout if no file)')
    .option('-q, --quiet', 'Suppress messages')
    .option('--css <file>', 'Specify custom CSS file')
    .option('--github <user/repo>', 'Link files to this Github repository')
    .option('--git-branch <branch>', 'Branch of Git to link to [master]', 'master')
    .on('--help', ->
      console.log "At least --output and/or --index must be used."
      console.log ""
      console.log "  Example:"
      console.log ""
      console.log "    $ #{options.name} lib/**/*.js --output docs"
      console.log "    $ #{options.name} **/*.rb --index project.json"
      console.log ""
    )
  options

# ### work()

# Parses command line arguments and performs actions.

work = (argv) ->
  options = getOptions()

  #- Parse the commands.
  options.parse(argv)
  options.files = options.args

  #- Do some sanity checks.
  if options.files.length is 0
    console.warn "No files to work on."
    console.warn "See `#{options.name} --help` for more information."
    process.exit 1

  if !options.index and !options.output
    console.warn "Nothing to do. Try using --output to write to a directory:"
    console.warn ""
    console.warn "    #{options.name} **/*.js --output docs"
    console.warn ""
    console.warn "See `#{options.name} --help` for more information."
    process.exit 15

  #- Do the actual parsing.
  Lidoc.parse options, (output) ->
    if options.index
      out = JSON.stringify(output, null, 2)

      if options.index is true
        console.log out
      else
        fs.writeFileSync(options.json, out)

    if options.output
      Lidoc.build output, options, (err, results) ->
        console.warn "Done."  unless options.quiet

Command = module.exports = {work, getOptions}
