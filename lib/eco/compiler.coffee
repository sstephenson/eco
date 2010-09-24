CoffeeScript = require "coffee-script"
{preprocess} = require "eco/preprocessor"
{indent}     = require "eco/util"

exports.compile = compile = (source, options) ->
  identifier = options?.identifier ? "module.exports"
  identifier = "var #{identifier}" unless identifier.match(/\./)
  script     = CoffeeScript.compile preprocess(source), noWrap: true

  """
    #{identifier} = function(__obj) {
      if (!__obj) __obj = {};
      var __out = [], __capture = function(callback) {
        var out = __out, result;
        __out = [];
        callback.call(this);
        result = __out.join('');
        __out = out;
        return __safe(result);
      }, __sanitize = function(value) {
        if (value && value.ecoSafe) {
          return value;
        } else if (typeof value !== 'undefined' && value != null) {
          return __escape(value);
        } else {
          return '';
        }
      }, __safe, __objSafe = __obj.safe, __escape = __obj.escape;
      __safe = __obj.safe = function(value) {
        if (value && value.ecoSafe) {
          return value;
        } else {
          if (!(typeof value !== 'undefined' && value != null)) value = '';
          var result = new String(value);
          result.ecoSafe = true;
          return result;
        }
      };
      if (!__escape) {
        __escape = __obj.escape = function(value) {
          return ('' + value)
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/\x22/g, '&quot;');
        };
      }
      (function() {
    #{indent script, 4}
      }).call(__obj);
      __obj.safe = __objSafe, __obj.escape = __escape;
      return __out.join('');
    };
  """

exports.link = link = (source) ->
  (new Function "module", compile source) module = {}
  module.exports

exports.render = (source, data) ->
  (link source) data

if require.extensions
  require.extensions[".eco"] = (module, filename) ->
    source = require("fs").readFileSync filename, "utf-8"
    module._compile compile(source), filename

else if require.registerExtension
  require.registerExtension ".eco", compile
