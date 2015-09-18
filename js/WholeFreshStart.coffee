---
---

# coffeescript cfaarpbdasfadf

n = 42

square = (x) -> x*x

math =
  root: Math.sqrt
  square: square
  cube: (x) -> x*square x

sqrt_pi = math.root(3.1415926536)

document.write """ <blockquote> "It's #{sqrt_pi}!"</blockquote> """
