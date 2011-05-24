(function() {
  var compileFile, each, eco, fs, indent, parseOptions, path, preprocessArgs, printUsage, printVersion, read, sys;
  var __slice = Array.prototype.slice;
  fs = require("fs");
  path = require("path");
  sys = require("sys");
  eco = require(".");
  indent = require("./util").indent;
  printUsage = function() {
    console.error("\nUsage: eco [options] path/to/template.eco\n\n  -o, --output [DIR]  set the directory for compiled JavaScript\n  -p, --print         print the compiled JavaScript to stdout\n  -s, --stdio         listen for and compile templates over stdio\n  -v, --version       display Eco version\n  -h, --help          display this help message\n");
    return process.exit(1);
  };
  printVersion = function() {
    var package;
    package = JSON.parse(fs.readFileSync(__dirname + "/../package.json", "utf8"));
    console.error("Eco version " + package.version);
    return process.exit(0);
  };
  preprocessArgs = function(args) {
    var arg, char, match, result, _i, _j, _len, _len2, _ref;
    result = [];
    for (_i = 0, _len = args.length; _i < _len; _i++) {
      arg = args[_i];
      if (match = /^-([a-z]{2,})/.exec(arg)) {
        _ref = match[1].split('');
        for (_j = 0, _len2 = _ref.length; _j < _len2; _j++) {
          char = _ref[_j];
          result.push("-" + char);
        }
      } else {
        result.push(arg);
      }
    }
    return result;
  };
  parseOptions = function(args) {
    var arg, option, options, _i, _len, _ref;
    options = {
      files: []
    };
    option = null;
    _ref = preprocessArgs(args);
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      arg = _ref[_i];
      if (option) {
        options[option] = arg;
        option = null;
      } else {
        switch (arg) {
          case "-o":
          case "--output":
            option = "output";
            break;
          case "-p":
          case "--print":
            options.print = true;
            break;
          case "-s":
          case "--stdio":
            options.stdio = true;
            break;
          case "-v":
          case "--version":
            printVersion();
            break;
          default:
            if (/^-/.test(arg)) {
              printUsage();
            } else {
              options.files.push(arg);
            }
        }
      }
    }
    if (option) {
      printUsage();
    }
    return options;
  };
  read = function(stream, callback) {
    var buffer;
    buffer = "";
    stream.setEncoding("utf8");
    stream.on("data", function(data) {
      return buffer += data;
    });
    return stream.on("end", function() {
      return typeof callback === "function" ? callback(buffer) : void 0;
    });
  };
  each = function(_arg, callback) {
    var proceed, values;
    values = 1 <= _arg.length ? __slice.call(_arg, 0) : [];
    return (proceed = function() {
      return callback(values.shift(), proceed);
    })();
  };
  compileFile = function(infile, callback) {
    var basename;
    basename = path.basename(infile).replace(/(\.eco)?$/, "");
    return fs.readFile(infile, "utf8", function(err, source) {
      var template;
      if (err) {
        return callback(err);
      }
      template = indent(eco.compile(source), 2);
      return callback(null, basename, "(function() {\n  this.ecoTemplates || (this.ecoTemplates = {});\n  this.ecoTemplates[" + (JSON.stringify(basename)) + "] = " + (template.slice(2)) + ";\n}).call(this);");
    });
  };
  exports.run = function(args) {
    var options;
    if (args == null) {
      args = process.argv.slice(2);
    }
    options = parseOptions(args);
    if (options.stdio) {
      if (options.files.length || options.output) {
        printUsage();
      }
      process.openStdin();
      return read(process.stdin, function(source) {
        return sys.puts(eco.compile(source));
      });
    } else if (options.print) {
      if (options.files.length !== 1 || options.output) {
        printUsage();
      }
      return compileFile(options.files[0], function(err, basename, result) {
        if (err) {
          throw err;
        }
        return sys.puts(result);
      });
    } else {
      if (!options.files.length) {
        printUsage();
      }
      return each(options.files, function(infile, proceed) {
        if (infile == null) {
          return;
        }
        return compileFile(infile, function(err, basename, result) {
          var outdir, outfile, _ref;
          if (err) {
            throw err;
          }
          outdir = (_ref = options.output) != null ? _ref : path.dirname(infile);
          outfile = path.join(outdir, basename + ".eco");
          return fs.writeFile(outfile, result, "utf8", function(err) {
            if (err) {
              return callback(err);
            }
            console.error("Compiled " + infile + " -> " + outfile);
            return proceed();
          });
        });
      });
    }
  };
}).call(this);
