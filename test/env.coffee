fs = require 'fs'

global.Vows = require("vows")
global.assert = require("assert")
global.Lidoc = require("lib/lidoc")

assert.nonEmptyFile = (fname) ->
  fs.readFile fname, (err, data) ->
    assert.isNull err
    assert data.length > 0

