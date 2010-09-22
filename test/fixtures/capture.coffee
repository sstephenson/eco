renderItem = (item) =>
  capture =>
    print safe '\n  <div class="item">\n    <span class="name">'
    print item.name
    print safe '</span>\n    <span class="price">$'
    print item.price
    print safe '</span>\n  </div>\n'
print safe '\n\n'
for item in @items
  print safe '\n  '
  print renderItem item
  print safe '\n'
print safe '\n'
