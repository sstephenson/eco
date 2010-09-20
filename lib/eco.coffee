indent = (string, width) ->
  space = new Array(width + 1).join " "
  lines = space + line for line in string.split "\n"
  lines.join "\n"

exports.compile = compile = (source) ->
  CoffeeScript = require "coffee-script"
  {preprocess} = require "eco/preprocessor"

  script = CoffeeScript.compile preprocess(source), noWrap: true

  """
    var __merge = function(a, b) {
      var result = {}, key;
      for (key in a) result[key] = a[key];
      for (key in b) result[key] = b[key];
      return result;
    };
    module.exports = function(__obj) {
      var __out = [];
      var print = function() {
        __out.push.apply(__out, arguments);
      };
      var capture = function(callback) {
        var out = __out, result;
        __out = [];
        callback.call(this);
        result = __out.join("");
        __out = out;
        return result;
      };
      (function() {
    #{indent script, 4}
      }).call(__merge(__obj, {
        print: print,
        capture: capture
      }));
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
