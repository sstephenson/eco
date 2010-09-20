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
    var _a, _b, _c, project;
    if (this.projects.length) {
      print('\n  ');
      _b = this.projects;
      for (_a = 0, _c = _b.length; _a < _c; _a++) {
        project = _b[_a];
        print('\n    <a href="');
        print(project.url);
        print('">');
        print(project.name);
        print('</a>\n  ');
      }
      print('\n');
    } else {
      print('\n  No projects\n');
    }
    print('\n');
  }).call(__merge(__obj, {
    print: print,
    capture: capture
  }));
  return __out.join("");
};
