for item in @items
  @print @safe '\n  '
  @print @contentTag "div", class: "item", =>
    @print @safe '\n    '
    @print @contentTag "span", class: "price", ->
      @print @safe '$'
      @print item.price
    @print @safe '\n    '
    @print @contentTag "span", class: "name", ->
      @print item.name
    @print @safe '\n  '
  @print @safe '\n'
@print @safe '\n'
