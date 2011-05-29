eco     = require ".."
express = require "express"
http    = require "http"

module.exports =
  "registering eco in an express application": (test) ->
    test.expect 2

    app = express.createServer()
    app.register ".eco", eco
    app.set "views", __dirname + "/fixtures"
    app.get "/hello/:name", (req, res) ->
      res.render "hello.eco", name: req.params.name, layout: false

    app.listen ->
      host   = "localhost"
      {port} = app.address()
      path   = "/hello/Sam"

      http.get {host, port, path}, (res) ->
        test.same 200, res.statusCode

        body = ""
        res.setEncoding "utf8"
        res.on "data", (data) -> body += data
        res.on "end", ->
          test.same "Hello, Sam.\nI\'M SHOUTING AT YOU, SAM!\n", body

          app.close()
          test.done()
