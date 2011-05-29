{compile} = require "../lib/compiler"
{fixture} = require "./lib/fixtures"

module.exports =
  "compiling fixtures/hello.eco": (test) ->
    test.ok compile fixture("hello.eco")
    test.done()

  "compiling fixtures/projects.eco": (test) ->
    test.ok compile fixture("projects.eco")
    test.done()

  "compiling fixtures/helpers.eco": (test) ->
    test.ok compile fixture("helpers.eco")
    test.done()

  "parse error throws exception": (test) ->
    test.expect 1
    try
      compile "<% unclosed tag"
    catch err
      test.ok err.toString().match /^Parse error on line 1/
    test.done()
