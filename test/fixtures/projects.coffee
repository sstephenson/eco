print ''
if @projects.length
  print '\n  '
  for project in @projects
    print '\n    <a href="'
    print project.url
    print '">'
    print project.name
    print '</a>\n  '
  print '\n'
else
  print '\n  No projects\n'
print '\n'
