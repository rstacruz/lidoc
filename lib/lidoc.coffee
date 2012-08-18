# # Lidoc
# yes.

# ### build()

# Bulids a project. See {Builder.build}.
#
{build} = require './lidoc/builder'

# ### parse()

{parse} = require './lidoc/parser'

module.exports = {build, parse}
