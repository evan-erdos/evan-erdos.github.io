---
layout: sketch
title: Synaptic Chaos
tag: [Programming, GameDev]
permalink: /sketch/mania.coffee/
script: /js/mania.js
---

Well, here we are. *This is __actually__ your brain on drugs*. None of that other nonsense, with eggs, frying pans... Jeez, what even was that commercial? What were we thinking? Who green-lit that whole thing? Anyways, code.

```coffee
### Ben Scott # 2015-10-12 # Mania ###

'use strict' # just like JavaScript
```


### `P5.js` Main class ###

This is our instance of the main class in the `P5.js` library.
The argument is the link between the library and this code, and
the special functions we override in the class definition are
callbacks for P5.js events.

```coffee
myp = new p5 (p) ->

    ### Input ###
    mouse = [p.mouseX,p.mouseY]
    lastMouse = [p.pmouseX,p.pmouseY]

    ### DOM ###
    [container,canvas] = [null,null]

    ### Resources ###
    [bg_img,dope_img] = [null,null]

    ### Domain ###
    neurotransmitters = []
```

### `Dopamine` ###

This is a class which represents the neurotransmitter
Dopamine, which is responsible for pleasure and euphoria.

- `@a`: acceleration
- `@v`: velocity
- `@max_v`: maximum speed
- `@max_f`: maximum force
- `@r`: radius
- `@pos`: current position
- `@tgt`: target position

```coffee
class Dopamine
    @max_v = 3
    @max_f = 0.05

    constructor: (@r=1,@pos,@tgt) ->
        @a = p.createVector(0,0)
        @v = p.createVector(p.random(-1,1),p.random(-1,1))

    run: (group) ->
        @flock(group)
        @update()
        @draw()

    applyForce: (f) ->
        @a.add(f)

    flock: (group) ->
        sep = @separate(group)
        ali = @align(group)
        coh = @cohesion(group)

        sep.mult(1.5)
        ali.mult(1)
        coh.mult(1)

        @applyForce(sep)
        @applyForce(ali)
        @applyForce(coh)

    update: ->
        @v.add(@a)
        @v.limit(@max_v)
        @pos.add(@v)
        @a.mult(0)

    seek: (tgt) ->
        dest = p5.Vector.sub(tgt,@pos)
        dest.normalize()
        dest.mult(@max_v)
        steer = p5.Vector.sub(dest,@v)
        steer.limit(@max_f)
        return steer

    draw: ->
        p.push()
        p.fill(127)
        p.stroke(200)
        p.translate(@pos.x,@pos.y)
        p.circle(@r)
        p.pop()

    separate: (group) ->
        [tgt,n] = [25,0]
        steer = p.createVector(0,0)
        for i in [0...group.length]
            d = p5.Vector.dist(@pos,group[i].pos)
            if (0<d<tgt)
                diff = p5.Vector.sub(@pos,group[i].pos)
                diff.normalize()
                diff.div(d)
                steer.add(diff)
                n++
        steer.div(n) if (n>0)
        if (steer.mag()>0)
            steer.normalize()
            steer.mult(@max_v)
            steer.sub(@v)
            steer.limit(@max_f)
        return steer

    align: (group) ->
        [dist,n] = [50,0]
        sum = p.CreateVector(0,0)
        for i in [0...group.length]
            d = p5.Vector.dist(@pos,group[i].pos)
            if (0<d<dist)
                sum.add(group[i].v)
                n++
        return createVector(0,0) unless (n>0)
        sum.div(n)
        sum.normalize()
        sum.mult(@max_v)
        steer = p5.Vector.sub(sum,@v)
        steer.limit(@max_f)
        return steer

    cohesion: (group) ->
        [dist,n] = [50,0]
        sum = p.createVector(0,0)
        for i in [0...group.length]
            d = p5.Vector.dist(@pos,group[i].pos)
            if (0<d<dist)
                sum.add(group[i].pos)
                n++
        return p.createVector(0,0) unless (n>0)
        sum.div(n)
        return @seek(sum)
```


More to Come!
