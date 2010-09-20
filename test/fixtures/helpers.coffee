for item in @items
  print '\n  '
  print @contentTag "div", class: "item", ->
    print '\n    '
    print @contentTag "span", class: "price", ->
      print '$'
      print item.price
    print '\n    '
    print @contentTag "span", class: "name", ->
      print item.name
    print '\n  '
  print '\n'
print '\n'
