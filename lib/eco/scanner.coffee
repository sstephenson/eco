{StringScanner} = require "strscan"

exports.scan = (source) ->
  tokens  = []
  scanner = new Scanner source
  until scanner.done
    scanner.scan (token) -> tokens.push token
  tokens

exports.Scanner = class Scanner
  @patterns: {
    data: /(.*?)(\{([:-])(=?)|\n|$)/
    code: /(.*?)(([:+])\}|\n|$)/
  }

  constructor: (source) ->
    @source  = source.replace /\r\n?/g, "\n"
    @scanner = new StringScanner @source
    @mode    = "data"
    @buffer  = ""
    @lineNo  = 1
    @done    = no

  scan: (callback) ->
    if @done
      callback()

    else if @scanner.hasTerminated()
      @done = yes
      switch @mode
        when "data"
          callback ["printString", @flush()]
        when "code"
          callback ["fail", "unexpected end of template"]

    else
      @advance()
      switch @mode
        when "data"
          @scanData callback
        when "code"
          @scanCode callback

  advance: ->
    @scanner.scanUntil @constructor.patterns[@mode]
    @buffer   += @scanner.getCapture 0
    @tail      = @scanner.getCapture 1
    @directive = @scanner.getCapture 2
    @printing  = @scanner.getCapture 3

  scanData: (callback) ->
    if @directive
      callback ["printString", @flush()]
      callback ["dedent"] if @directive is "-"
      callback ["beginCode", print: @printing is "="]
      @mode = "code"

    else if @tail is "\n"
      @buffer += @tail
      @lineNo++
      @scan callback

  scanCode: (callback) ->
    if @directive
      callback ["recordCode", @flush()]
      callback ["indent"] if @directive is "+"
      @mode = "data"

    else if @tail is "\n"
      callback ["fail", "unexpected newline in code block"]

  flush: ->
    buffer  = @buffer
    @buffer = ""
    buffer
