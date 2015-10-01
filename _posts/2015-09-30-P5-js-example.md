---
layout: post
title: P5.js Example
tag: Programming
---


J5 & CoffeeScript
-----------------

This program draws circles. [Click Here][].

```CoffeeScript
# CoffeeScript Sketch

myp = new p5 (p)->
  p.setup = ->
    p.createCanvas p.windowWidth, p.windowHeight
    p.frameRate 60

  p.draw = ->
    [x,y] = [16,16]
    if p.mouseIsPressed
        p.fill(p.random 255,p.random 255,p.random 255,127)
        p.stroke "grey"
        n = p.random 4
        p.ellipse p.mouseX, p.mouseY, x*n, y*n

```

[Click Here]: </other/coffee_rings/>