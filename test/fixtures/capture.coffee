renderItem = (item) ->
  __capture ->
    __out.push '\n  <div class="item">\n    <span class="name">'
    __out.push __sanitize item.name
    __out.push '</span>\n    <span class="price">$'
    __out.push __sanitize item.price
    __out.push '</span>\n  </div>\n'
__out.push '\n\n'
for item in @items
  __out.push '\n  '
  __out.push __sanitize renderItem item
  __out.push '\n'
__out.push '\n'
