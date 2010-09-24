for item in @items
  __out.push '\n  '
  __out.push __sanitize @contentTag "div", class: "item", =>
    __capture =>
      __out.push '\n    '
      __out.push __sanitize @contentTag "span", class: "price", ->
        __capture ->
          __out.push '$'
          __out.push __sanitize item.price
      __out.push '\n    '
      __out.push __sanitize @contentTag "span", class: "name", ->
        __capture ->
          __out.push __sanitize item.name
      __out.push '\n  '
  __out.push '\n'
__out.push '\n'
