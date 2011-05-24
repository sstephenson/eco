fs   = require "fs"
path = require "path"
sys  = require "sys"
eco  = require "."

{indent} = require "./util"

printUsage = ->
  console.error """

    Usage: eco [options] path/to/template.eco

      -o, --output [DIR]  set the directory for compiled JavaScript
      -p, --print         print the compiled JavaScript to stdout
      -s, --stdio         listen for and compile templates over stdio
      -v, --version       display Eco version
      -h, --help          display this help message

  """
  process.exit 1

printVersion = ->
  package = JSON.parse fs.readFileSync __dirname + "/../package.json", "utf8"
  console.error "Eco version #{package.version}"
  process.exit 0

preprocessArgs = (args) ->
  result = []
  for arg in args
    if match = /^-([a-z]{2,})/.exec arg
      for char in match[1].split ''
        result.push "-#{char}"
    else
      result.push arg
  result

parseOptions = (args) ->
  options = files: []
  option = null

  for arg in preprocessArgs args
    if option
      options[option] = arg
      option = null
    else
      switch arg
        when "-o", "--output"  then option = "output"
        when "-p", "--print"   then options.print = true
        when "-s", "--stdio"   then options.stdio = true
        when "-v", "--version" then printVersion()
        else (if /^-/.test arg then printUsage() else options.files.push arg)

  printUsage() if option
  options

read = (stream, callback) ->
  buffer = ""
  stream.setEncoding "utf8"
  stream.on "data", (data) -> buffer += data
  stream.on "end", -> callback? buffer

each = ([values...], callback) ->
  do proceed = -> callback values.shift(), proceed

compileFile = (infile, callback) ->
  basename = path.basename(infile).replace /(\.eco)?$/, ""

  fs.readFile infile, "utf8", (err, source) ->
    return callback err if err
    template = indent eco.compile(source), 2

    callback null, basename, """
      (function() {
        this.ecoTemplates || (this.ecoTemplates = {});
        this.ecoTemplates[#{JSON.stringify basename}] = #{template.slice 2};
      }).call(this);
    """

exports.run = (args = process.argv.slice 2) ->
  options = parseOptions args

  if options.stdio
    printUsage() if options.files.length or options.output
    process.openStdin()
    read process.stdin, (source) ->
      sys.puts eco.compile source

  else if options.print
    printUsage() if options.files.length isnt 1 or options.output
    compileFile options.files[0], (err, basename, result) ->
      throw err if err
      sys.puts result

  else
    printUsage() unless options.files.length
    each options.files, (infile, proceed) ->
      return unless infile?
      compileFile infile, (err, basename, result) ->
        throw err if err

        outdir  = options.output ? path.dirname infile
        outfile = path.join outdir, basename + ".eco"

        fs.writeFile outfile, result, "utf8", (err) ->
          throw err if err
          console.error "Compiled #{infile} -> #{outfile}"
          proceed()
