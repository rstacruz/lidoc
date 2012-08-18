# # Lidoc/Command
# Lidoc command line tool.

Lidoc = require '../lidoc'
fs = require 'fs'

# ### Command line parser

# Bulid the command line parser using `commander`.
options = require 'commander'
options
  .version('0.0.1')
  .usage("<sourcefile ...> [options]")
  .option('-o, --output <path>', 'Write documentation output into this path')
  .option('-j, --json [file]', 'Write JSON info into file (use stdout if no file)')
  .option('--css <file>', 'Specify custom CSS file')
  .option('--extra-css <file>', 'Specify extra CSS rules')
  .option('--html <file>', 'Specify custom HTML file')
  .on('--help', ->
    console.log "At least --output and/or --json must be used."
    console.log ""
    console.log "  Example:"
    console.log ""
    console.log "    $ #{options.name} lib/**/*.js --output docs"
    console.log "    $ #{options.name} **/*.rb --json project.json"
    console.log ""
  )

# Now let's work.

#- Parse the commands.
options.parse(process.argv)
options.files = options.args

#- Do some sanity checks.
if options.files.length is 0
  console.warn "No files to work on."
  console.warn "See `#{options.name} --help` for more information."
  process.exit 1

if !options.json and !options.output
  console.warn "Nothing to do. Try using --output to write to a directory:"
  console.warn ""
  console.warn "    #{options.name} **/*.js --output docs"
  console.warn ""
  console.warn "See `#{options.name} --help` for more information."
  process.exit 15

#- Do the actual parsing.
Lidoc.parse options, (output) ->
  if options.json
    out = JSON.stringify(output, null, 2)

    if options.json is true
      console.log out
    else
      fs.writeFileSync(options.json, out)

  if options.output
    Lidoc.build(output, options)

