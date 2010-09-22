for item in @items
  print safe '\n  '
  print @contentTag "div", class: "item", =>
    capture =>
      print safe '\n    '
      print @contentTag "span", class: "price", ->
        capture ->
          print safe '$'
          print item.price
      print safe '\n    '
      print @contentTag "span", class: "name", ->
        capture ->
          print item.name
      print safe '\n  '
  print safe '\n'
print safe '\n'
