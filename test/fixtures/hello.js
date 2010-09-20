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
    print('Hello, ');
print(this.name);
print('.\nI\'M SHOUTING AT YOU, ');
print(this.name.toUpperCase());
print('!\n');
  }).call(__merge(__obj, {
    print: print,
    capture: capture
  }));
  return __out.join("");
};
