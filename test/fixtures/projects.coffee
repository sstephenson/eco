if @projects.length
  __out.push '\n  '
  for project in @projects
    __out.push '\n    <a href="'
    __out.push __sanitize project.url
    __out.push '">'
    __out.push __sanitize project.name
    __out.push '</a>\n    '
    __out.push project.description
    __out.push '\n  '
  __out.push '\n'
else
  __out.push '\n  No projects\n'
__out.push '\n'
