module.exports = function(__obj) {
  return (function() {
    this.print(this.safe('Hello, '));
    this.print(this.name);
    this.print(this.safe('.\nI\'M SHOUTING AT YOU, '));
    this.print(this.name.toUpperCase());
    this.print(this.safe('!\n'));
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