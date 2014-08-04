Command line wrapper.

    doc = """
    Usage:
      doc-n-toc [options] [<markdown_files>...]

    Turn markdown files into a single page with a table of contents.

      --help             Show the help
      --title=title      Title for the page
    """
    {docopt} = require 'docopt'
    args = docopt(doc)
    {builder} = require 'polymer-build'
    async = require 'async'
    handlebars = require 'handlebars'
    fs = require 'fs'
    path = require 'path'
    _ = require 'lodash'

    async.waterfall [
      (callback) ->
        fs.readFile path.join(__dirname, 'index.html.mustache'), 'utf8', callback
    ,
      (template, callback) ->
        try
          callback undefined, handlebars.compile(template)
        catch e
          callback e
    ,
      (template, callback) ->
        try
          callback undefined, template
            markdown_files: _.map args['<markdown_files>'], (filename) -> path.resolve(filename)
            title: args['--title']
        catch e
          callback e
    ,
      (template, callback) ->
        builder({'--quiet': false, '--source': true, '--cwd': path.join(__dirname, 'index.html')}) template, callback
    ,
      (final, callback) ->
        process.stdout.write final
    ]
