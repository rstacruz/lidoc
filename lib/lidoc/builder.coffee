# # Lidoc.Builder

build = (project, options) ->
  for fname, file in project.files
    console.log "  #{file}"

module.exports = {build}
