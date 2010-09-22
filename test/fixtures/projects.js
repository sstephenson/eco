module.exports = function(__obj) {
  return (function() {
    var _i, _len, _ref, project;
    if (this.projects.length) {
      this.print(this.safe('\n  '));
      _ref = this.projects;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        project = _ref[_i];
        this.print(this.safe('\n    <a href="'));
        this.print(project.url);
        this.print(this.safe('">'));
        this.print(project.name);
        this.print(this.safe('</a>\n  '));
      }
      this.print(this.safe('\n'));
    } else {
      this.print(this.safe('\n  No projects\n'));
    }
    this.print(this.safe('\n'));
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