{Scanner} = require "eco/scanner"
{repeat}  = require "eco/util"
sys       = require "sys"

exports.preprocess = (source) ->
  preprocessor = new Preprocessor source
  preprocessor.preprocess()

exports.Preprocessor = class Preprocessor
  constructor: (source) ->
    @scanner  = new Scanner source
    @output   = ""
    @level    = 0
    @printing = no
    @captures = []

  preprocess: ->
    until @scanner.done
      @scanner.scan (token) =>
        @[token[0]].apply @, token.slice 1
    @output

  record: (line) ->
    @output += repeat "  ", @level
    @output += line + "\n"

  printString: (string) ->
    if string.length
      @record "print safe #{sys.inspect string}"

  beginCode: (options) ->
    @printing = options.print

  recordCode: (code) ->
    if code isnt "end"
      if @printing
        @printing = no
        @record "print #{code}"
      else
        @record code

  indent: (capture) ->
    @level++
    if capture
      @record "capture #{capture}"
      @captures.unshift @level
      @indent()

  dedent: ->
    @level--
    @fail "unexpected dedent" if @level < 0
    if @captures[0] is @level
      @captures.shift()
      @dedent()

  fail: (message) ->
    throw "Parse error on line #{@scanner.lineNo}: #{message}"
