require.paths.unshift __dirname + '/lib', __dirname + '/test/lib'

task 'test', 'Run tests', ->
  {testrunner} = require 'nodeunit'
  process.chdir __dirname
  testrunner.run ['test']
