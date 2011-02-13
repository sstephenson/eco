require.paths.unshift "#{__dirname}/lib"

task "build", "Build lib/eco/ from src/eco/", ->
  require('child_process').exec 'coffee -co lib src'

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

task "doc", "Generate documentation", ->
  fs  = require "fs"
  eco = require "eco"
  dir = "#{__dirname}/doc"

  render = (path) ->
    template = fs.readFileSync "#{dir}/#{path}.md.eco", "utf-8"
    eco.render template, include: render

  fs.writeFileSync "#{__dirname}/README.md", render "readme"

task "dist", "Generate dist/eco.js", ->
  fs     = require("fs")
  coffee = require("coffee-script").compile
  minify = require("closure-compiler").compile

  read = (filename) ->
    fs.readFileSync "#{__dirname}/#{filename}", "utf-8"

  stub = (identifier) -> """
    if (typeof #{identifier} !== 'undefined' && #{identifier} != null) {
      module.exports = #{identifier};
    } else {
      throw 'Cannot require \\'' + module.id + '\\': #{identifier} not found';
    }
  """

  version = JSON.parse(read "package.json").version

  modules =
    "eco":              read "lib/eco.js"
    "eco/compiler":     coffee read "lib/eco/compiler.coffee"
    "eco/preprocessor": coffee read "lib/eco/preprocessor.coffee"
    "eco/scanner":      coffee read "lib/eco/scanner.coffee"
    "eco/util":         coffee read "lib/eco/util.coffee"
    "strscan":          read "vendor/strscan/lib/strscan.js"
    "coffee-script":    stub "CoffeeScript"

  package = for name, source of modules
    """
      '#{name}': function(module, require, exports) {
        #{source}
      }
    """

  header = """
    /**
     * Eco Compiler v#{version}
     * http://github.com/sstephenson/eco
     *
     * Copyright (c) 2010 Sam Stephenson
     * Released under the MIT License
     */
  """

  source = """
    this.eco = (function(modules) {
      return function require(name) {
        var fn, module = {id: name, exports: {}};
        if (fn = modules[name]) {
          fn(module, require, module.exports);
          return module.exports;
        } else {
          throw 'Cannot find module \\'' + name + '\\'';
        }
      };
    })({
      #{package.join ',\n'}
    })('eco');
  """

  try
    fs.mkdirSync "#{__dirname}/dist", 0755
  catch err

  minify source, {}, (output) ->
    fs.writeFileSync "#{__dirname}/dist/eco.js", "#{header}\n#{output}"
