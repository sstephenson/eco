exports.compile = compile = (source) ->
  CoffeeScript = require "coffee-script"
  {preprocess} = require "eco/preprocessor"

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

if require.extensions
  require.extensions[".eco"] = (module, filename) ->
    source = require("fs").readFileSync filename, "utf-8"
    module._compile compile(source), filename

else if require.registerExtension
  require.registerExtension ".eco", compile
