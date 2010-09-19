{scan} = require "eco/scanner"

module.exports =
  "{: begins a code block": (test) ->
    tokens = scan "{:"
    test.same ["printString", ""], tokens.shift()
    test.same ["beginCode", print: false], tokens.shift()
    test.done()

  "{:= begins a print block": (test) ->
    tokens = scan "{:="
    test.same ["printString", ""], tokens.shift()
    test.same ["beginCode", print: true], tokens.shift()
    test.done()

  "{- dedents and begins a code block": (test) ->
    tokens = scan "{-"
    test.same ["printString", ""], tokens.shift()
    test.same ["dedent"], tokens.shift()
    test.same ["beginCode", print: false], tokens.shift()
    test.done()

  "{-= dedents and begins a print block": (test) ->
    tokens = scan "{-="
    test.same ["printString", ""], tokens.shift()
    test.same ["dedent"], tokens.shift()
    test.same ["beginCode", print: true], tokens.shift()
    test.done()

  ":} ends a code block": (test) ->
    tokens = scan "{: code goes here :}"
    test.same ["printString", ""], tokens.shift()
    test.same ["beginCode", print: false], tokens.shift()
    test.same ["recordCode", " code goes here "], tokens.shift()
    test.same ["printString", ""], tokens.shift()
    test.done()

  "-} ends a code block and indents": (test) ->
    tokens = scan "{: for project in @projects -}"
    test.same ["printString", ""], tokens.shift()
    test.same ["beginCode", print: false], tokens.shift()
    test.same ["recordCode", " for project in @projects "], tokens.shift()
    test.same ["indent"], tokens.shift()
    test.done()

  "unexpected newline in code block": (test) ->
    tokens = scan "foo\nhello {: do 'thing'\n :}"
    test.same ["printString", "foo\nhello "], tokens.shift()
    test.same ["beginCode", print: false], tokens.shift()
    test.same ["fail", "unexpected newline in code block"], tokens.shift()
    test.done()

  "unexpected end of template": (test) ->
    tokens = scan "foo\nhello {: do 'thing'"
    test.same ["printString", "foo\nhello "], tokens.shift()
    test.same ["beginCode", print: false], tokens.shift()
    test.same ["fail", "unexpected end of template"], tokens.shift()
    test.done()

