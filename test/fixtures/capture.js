module.exports = function(__obj) {
  return (function() {
    var _i, _len, _ref, capture, item, print, renderItem, safe;
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
    renderItem = __bind(function(item) {
      return capture(__bind(function() {
        print(safe('\n  <div class="item">\n    <span class="name">'));
        print(item.name);
        print(safe('</span>\n    <span class="price">$'));
        print(item.price);
        return print(safe('</span>\n  </div>\n'));
      }, this));
    }, this);
    print(safe('\n\n'));
    _ref = this.items;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      item = _ref[_i];
      print(safe('\n  '));
      print(renderItem(item));
      print(safe('\n'));
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