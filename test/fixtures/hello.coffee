__out.push 'Hello, '
__out.push __sanitize @name
__out.push '.\nI\'M SHOUTING AT YOU, '
__out.push __sanitize @name.toUpperCase()
__out.push '!\n'
