eco       = require "eco"
{fixture} = require "fixtures"

module.exports =
  "rendering hello.eco": (test) ->
    test.expect 1
    output = eco.render fixture("hello.eco"), name: "Sam"
    test.same fixture("hello.out.1"), output
    test.done()

  "rendering hello.eco without a name throws an exception": (test) ->
    test.expect 1
    try
      eco.render fixture("hello.eco")
    catch err
      test.ok err
    test.done()

  "rendering projects.eco with empty projects array": (test) ->
    test.expect 1
    output = eco.render fixture("projects.eco"), projects: []
    test.same fixture("projects.out.1"), output
    test.done()

  "rendering projects.eco with multiple projects": (test) ->
    test.expect 1
    output = eco.render fixture("projects.eco"), projects: [
      { name: "PowerTMS Active Shipments Page Redesign", url: "/projects/1" },
      { name: "SCU Intranet", url: "/projects/2" },
      { name: "Sales Template", url: "/projects/3" }
    ]
    test.same fixture("projects.out.2"), output
    test.done()

