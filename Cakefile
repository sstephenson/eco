require.paths.unshift "#{__dirname}/lib"

task "test", "Run tests", ->
  require.paths.unshift "#{__dirname}/test/lib"
  process.chdir __dirname
  {reporters} = require 'nodeunit'
  reporters.default.run ['test']

task "fixtures", "Generate .coffee fixtures from .eco fixtures", ->
  fs   = require "fs"
  path = require "path"
  dir  = "#{__dirname}/test/fixtures"

  for filename in fs.readdirSync dir
    if path.extname(filename) is ".eco"
      eco          = require "eco"
      {preprocess} = require "eco/preprocessor"
      basename     = path.basename filename, ".eco"
      source       = fs.readFileSync "#{dir}/#{filename}", "utf-8"
      fs.writeFileSync "#{dir}/#{basename}.coffee", preprocess source
