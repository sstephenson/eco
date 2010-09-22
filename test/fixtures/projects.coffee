if @projects.length
  @print @safe '\n  '
  for project in @projects
    @print @safe '\n    <a href="'
    @print project.url
    @print @safe '">'
    @print project.name
    @print @safe '</a>\n  '
  @print @safe '\n'
else
  @print @safe '\n  No projects\n'
@print @safe '\n'
