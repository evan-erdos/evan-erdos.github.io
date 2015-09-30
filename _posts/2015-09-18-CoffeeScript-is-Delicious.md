---
layout: post
title: CoffeeScript is Delicious
tag: GameDev
---

CoffeeScript is really doing a number on this webpage right now.

> We're gonna... drop it down there, just get a whole fresh start, Morty, create a whole... fresh start.
> Come on, Morty, just take it easy, Morty. It's gonna be goooodd.
> Now listen! I need your help Morty! I mean, we got, we gotta get, get the hell out of here; and go take care of business __\*burp\*__ __\*burp\*__ it's important __\*geuuhh\*__ come on Morty!

```coffeescript
n = 42 # coffeescript cfaarpbdasfadf

square = (x) -> x*x

math =
  root: Math.sqrt
  square: square
  cube: (x) -> x*square x
```

> "Quick, Morty! What's the square root of PI?"
> "Aw, come on Rick, you know I can't!"
> "MORTY!"

```coffeescript
sqrt_pi = math.root(3.1415926536)

document.write """ "It's #{sqrt_pi}!" """
```

<script src="/js/WholeFreshStart.js"></script>
