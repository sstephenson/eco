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
    var _a, _b, _c;
    var __bind = function(func, context) {
        return function(){ return func.apply(context, arguments); };
      };
    _b = this.items;
    for (_a = 0, _c = _b.length; _a < _c; _a++) {
      (function() {
        var item = _b[_a];
        print('\n  ');
        print(this.contentTag("div", {
          "class": "item"
        }, __bind(function() {
          print('\n    ');
          print(this.contentTag("span", {
            "class": "price"
          }, function() {
            print('$');
            return print(item.price);
          }));
          print('\n    ');
          print(this.contentTag("span", {
            "class": "name"
          }, function() {
            return print(item.name);
          }));
          return print('\n  ');
        }, this)));
        return print('\n');
      }).call(this);
    }
    print('\n');
  }).call(__merge(__obj, {
    print: print,
    capture: capture
  }));
  return __out.join("");
};
