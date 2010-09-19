CoffeeScript = require "coffee-script"
{preprocess} = require "eco/preprocessor"

exports.compile = compile = (source) ->
  """
    module.exports = function(__obj) {
      var __out = [];
      var print = function() {
        __out.push.apply(__out, arguments);
      };
      (function() {
        #{CoffeeScript.compile preprocess(source), noWrap: true}
      }).call(__obj);
      return __out.join("");
    };\n
  """

exports.render = (source, data) ->
  module = {}
  template = new Function "module", compile source
  template module
  module.exports data

if require.registerExtension
  require.registerExtension ".eco", compile
