CoffeeScript = require "coffee-script"
{preprocess} = require "eco/preprocessor"
{indent}     = require "eco/util"

exports.compile = compile = (source) ->
  bindings = """
    print = (value) => @print value
    capture = (callback) => @capture callback
    safe = (value) => @safe value\n
  """

  coffee = bindings + preprocess source
  script = CoffeeScript.compile coffee, noWrap: true

  """
    module.exports = function(__obj) {
      return (function() {
    #{indent script, 4}
        return this.toString();
      }).call((function() {
        var key, out = [], obj = {
          print: function(value) {
            if (typeof value !== 'undefined' && value != null)
              out.push(this.sanitize(value));
          },
          capture: function(callback) {
            var oldOut = out, result;
            out = [];
            callback.call(this);
            result = out.join("");
            out = oldOut;
            return this.safe(result);
          },
          sanitize: function(value) {
            return value.ecoSafe ? value : this.escape(value);
          },
          escape: function(value) {
            return ('' + value)
              .replace(/&/g, '&amp;')
              .replace(/</g, '&lt;')
              .replace(/>/g, '&gt;')
              .replace(/"/g, '&quot;');
          },
          safe: function(value) {
            var result = new String(value);
            result.ecoSafe = true;
            return result;
          },
          toString: function() {
            return out.join("");
          }
        };
        for (key in __obj) obj[key] = __obj[key];
        return obj;
      })());
    }
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
