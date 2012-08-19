fs = require 'fs'

global.Vows = require("vows")
global.assert = require("assert")
global.Lidoc = require("lib/lidoc")

global.pending = -> "pending"

assert.nonEmptyFile = (fname) ->
  fs.readFile fname, (err, data) ->
    assert.isNull err, "File not found: #{fname}"
    assert data.length > 0, "File is empty: #{fname}"
