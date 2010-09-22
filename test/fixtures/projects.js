module.exports = function(__obj) {
  return (function() {
    var _i, _len, _ref, capture, print, project, safe;
    var __bind = function(func, context) {
        return function(){ return func.apply(context, arguments); };
      };
    print = __bind(function(value) {
      return this.print(value);
    }, this);
    capture = __bind(function(callback) {
      return this.capture(callback);
    }, this);
    safe = __bind(function(value) {
      return this.safe(value);
    }, this);
    if (this.projects.length) {
      print(safe('\n  '));
      _ref = this.projects;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        project = _ref[_i];
        print(safe('\n    <a href="'));
        print(project.url);
        print(safe('">'));
        print(project.name);
        print(safe('</a>\n  '));
      }
      print(safe('\n'));
    } else {
      print(safe('\n  No projects\n'));
    }
    print(safe('\n'));
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