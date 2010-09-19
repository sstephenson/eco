module.exports = function(__obj) {
  var __out = [];
  var print = function() {
    __out.push.apply(__out, arguments);
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
  }).call(__obj);
  return __out.join("");
};
