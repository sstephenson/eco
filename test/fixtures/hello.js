module.exports = function(__obj) {
  var __out = [];
  var print = function() {
    __out.push.apply(__out, arguments);
  };
  (function() {
    print('Hello, ');
print(this.name);
print('.\nI\'M SHOUTING AT YOU, ');
print(this.name.toUpperCase());
print('!\n');
  }).call(__obj);
  return __out.join("");
};
