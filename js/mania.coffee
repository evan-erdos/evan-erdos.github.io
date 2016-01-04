---
---

### Ben Scott # 2015-10-12 # Mania ###

'use strict' # just like JavaScript

### `P5.js` Main class

This is our instance of the main class in the `P5.js` library.
The argument is the link between the library and this code, and
the special functions we override in the class definition are
callbacks for P5.js events.
###
myp = new p5 (p) ->

  ### Input ###
  mouse = [p.mouseX,p.mouseY]
  lastMouse = [p.pmouseX,p.pmouseY]

  ### Library ###
  rand = p.random

  ### DOM ###
  [container,canvas] = [null,null]

  ### Assets ###
  [bg_img,dope_img] = [null,null]

  ### Mania ###
  manic = false
  [max_v,max_f,dope_rate] = [3,0.05,60]
  [receptors,transmitters] = [[],[]]


  ### `Neurotransmitter`

  This class represents a generic neurotransmitter, which
  the dopamine and amphetamine classes extend.
  - `@a` **real** : acceleration (m^2/ms)
  - `@v` **real** : velocity (m/ms)
  - `@m` **int** : mass (kg)
  - `@t` **real** : lifetime (ms)
  - `@pos` \<**real**,**real**\> : current position
  - `@tgt` \<**real**,**real**\> : target position
  ###
  class Neurotransmitter

    constructor: (@pos,@tgt,@m=1,@t=1024) ->
      @a = p.createVector(0,0)
      @v = p.createVector(rand(-1,1), rand(-1,1))
      @tgt = p.createVector(p.width/2,p.height/2)
      unless (@pos?)
        @pos = p.createVector(
          p.width/2+p.random(-50,50),-10)
        @v.y = p.random(1,2)

    run: (group) ->
      @flock(group)
      @update()
      @bounds()
      @draw()

    applyForce: (list...) ->
      @a.add(force)/@m for force in list

    flock: (group) ->
      @applyForce(
        @separate(group).mult(1.5)
        @align(group).mult(1)
        @cohesion(group).mult(1))

    seek: (tgt) ->
      @tgt = tgt
      len = p5.Vector.sub(tgt,@pos)
      len.normalize()
      len.mult(max_v)
      dir = p5.Vector.sub(len,@v)
      dir.limit(0.05)
      return dir

    bounds: ->
      return if (-10<@pos.x<p.width+10)
      unless (-10<@pos.y<p.height+10)
        transmitters.remove(this)
        delete this

    update: ->
      @v.add(@a)
      @v.limit(max_v)
      @pos.add(@v)
      @a = p.createVector(0,0)

    draw: ->
      p.push()
      polygon(@pos.x,@pos.y,5,6)
      p.pop()

  ### `Dopamine`

  This is a class which represents the neurotransmitter
  Dopamine, which is responsible for pleasure and euphoria.
  - `@a` **real** : acceleration (m^2/ms)
  - `@v` **real** : velocity (m/ms)
  - `@m` **int** : mass (kg)
  - `@t` **real** : lifetime (ms)
  - `@r` **int** : radius (pixel)
  - `@pos` \<**real**,**real**\> : current position
  - `@tgt` \<**real**,**real**\> : target position
  - `@max_v` **real** : maximum speed
  - `@max_f` **real** : maximum force
  ###
  class Dopamine extends Neurotransmitter

    flock: (group) ->
      super
      final_steer = @seek(
        p.createVector(p.width/2,p.height*2))
      final_steer.mult(0.5)
      @applyForce(final_steer)

    draw: ->
      p.push()
      value = p.map(value,0,255,60,120)
      p.fill(value,180,180)
      p.stroke(180)
      p.strokeWeight(2)
      if (manic && @pos.y>p.height/3)
        p.translate(rand(3),rand(3))
      p.line(@pos.x,@pos.y,@pos.x-8,@pos.y-4)
      p.line(@pos.x,@pos.y,@pos.x-8,@pos.y+4)
      p.line(@pos.x,@pos.y,@pos.x+8,@pos.y-4)
      p.line(@pos.x+8,@pos.y-4,@pos.x+12,@pos.y-2)
      polygon(@pos.x,@pos.y,5,6)
      p.pop()

    separate: (group) ->
      [tgt,n] = [20,0]
      dir = p.createVector(0,0)
      for elem in group
        d = p5.Vector.dist(@pos,elem.pos)
        if (0<d<tgt)
          diff = p5.Vector.sub(@pos,elem.pos)
          diff.normalize()
          diff.div(d)
          dir.add(diff)
          n++
      dir.div(n) if (n>0)
      if (0<dir.mag())
        dir.normalize()
        dir.mult(max_v)
        dir.sub(@v)
        dir.limit(0.05)
      return dir

    align: (group) ->
      [len,n] = [50.0,0]
      sum = p.createVector(0,0)
      for elem in group
        d = p5.Vector.dist(@pos,elem.pos)
        if (0<d<len)
          sum.add(elem.v)
          n++
      if (n>0)
        sum.div(n)
        sum.normalize()
        sum.mult(max_v)
        dir = p5.Vector.sub(sum,@v)
        dir.limit(0.05)
        return dir
      else return p.createVector(0,0)

    cohesion: (group) ->
      [len,n] = [50,0]
      dir = p.createVector(0,0)
      for elem in group
        d = p5.Vector.dist(@pos,elem.pos)
        if (0<d<=len)
          dir.add(elem.pos)
          n++
      if (n>0)
        dir.div(n)
        return @seek(dir)
      else return p.createVector(0,0)

  ### `Cocaine`

  This is a class which represents Cocaine, a dopamine
  reuptake inhibitor (obviously this is what it's known for)
  - `@a` **real** : acceleration (m^2/ms)
  - `@v` **real** : velocity (m/ms)
  - `@m` **int** : mass (kg)
  - `@t` **real** : lifetime (ms)
  - `@pos` \<**real**,**real**\> : current position
  - `@tgt` \<**real**,**real**\> : target position
  - `@n_tgt` \<**real**,**real**\> : clearing behaviour
  ###
  class Cocaine extends Dopamine
    @n_tgt = null

    constructor: ->
      super
      @t = 512+p.random(-128,128)
      @mass = 3
      @pos = p.createVector(p.mouseX,p.mouseY)
      @n_tgt = p.createVector(
        p.width/2+rand(-128,128)
        p.height/2+rand(-50,50))

    update: ->
      super
      @t--
      if (@t<0)
        @applyForce(@seek(p.createVector(
          p.width*2, rand(-30,30))).mult(3))

    draw: ->
      p.push()
      p.fill(255)
      p.stroke(200)
      p.line(@pos.x,@pos.y,@pos.x,@pos.y-8)
      p.line(@pos.x,@pos.y-8,@pos.x+2,@pos.y-12)
      p.line(@pos.x,@pos.y,@pos.x+8,@pos.y+4)
      p.line(@pos.x+8,@pos.y+4,@pos.x+12,@pos.y+6)
      polygon(@pos.x-4,@pos.y,5,6,30)
      polygon(@pos.x+4,@pos.y,5,6,30)
      p.pop()

    flock: (group) ->
      @applyForce(
        @separate(group)
        @seek(@n_tgt))

    separate: (group) ->
      [tgt,n] = [20,0]
      dir = p.createVector(0,0)
      for elem in group
        d = p5.Vector.dist(@pos,elem.pos)
        if (0<d<tgt)
          diff = p5.Vector.sub(elem.pos,@pos)
          diff.normalize()
          diff.div(d)
          dir.add(diff)
          n++
          unless (elem instanceof Cocaine)
            elem.applyForce(diff.normalize())
          else elem.applyForce(
            p.createVector())
      dir.div(n) if (n>0)
      if (0<dir.mag())
        dir.normalize()
        dir.mult(-1)
        dir.sub(@v)
        dir.limit(0.5)
      return dir

  ### `Amphetamine`

  The same neuron! Now with amphetamines! Amphetamines act
  as a releasing agent for dopamine, and are much easier
  to animate!
  - `@a` **real** : acceleration (m^2/ms)
  - `@v` **real** : velocity (m/ms)
  - `@m` **int** : mass (kg)
  - `@t` **real** : lifetime (ms)
  - `@pos` \<**real**,**real**\> : current position
  - `@tgt` \<**real**,**real**\> : target position
  - `@n_tgt` \<**real**,**real**\> : clearing behaviour
  ###
  class Amphetamine extends Dopamine
    @n_tgt = null

    constructor: (@pos,@tgt,@m=1,@t=1024) ->
      super
      @pos = p.createVector(p.mouseX,p.mouseY)
      @n_tgt = p.createVector(
        p.width/2-128+rand(-2,2)
        p.height/2-100+rand(-2,2))
      if (p.width/3<@pos.x)
        @n_tgt = p.createVector(
          p.width/2+128+rand(-2,2)
          p.height/2-100+rand(-2,2))

    update: ->
      super
      @t--
      if (@t<0)
        if (rand(2)>1)
          @applyForce(@seek(p.createVector(
            p.width*2, rand(-30,30))).mult(3))
        else @applyForce(@seek(p.createVector(
            p.width/2,-p.height).mult(3)))

    draw: ->
      p.push()
      p.fill(255,180,180)
      p.stroke(180)
      p.strokeWeight(2)
      p.line(@pos.x,@pos.y,@pos.x+8,@pos.y-4)
      p.line(@pos.x+8,@pos.y-4,@pos.x+12,@pos.y-2)
      polygon(@pos.x,@pos.y,5,6)
      p.pop()

    flock: (group) ->
      super
      @applyForce(@seek(@n_tgt))

    separate: (group) ->
      [tgt,n] = [20,0]
      dir = p.createVector(0,0)
      for elem in group
        d = p5.Vector.dist(@pos,elem.pos)
        if (0<d<tgt)
          diff = p5.Vector.sub(elem.pos,@pos)
          diff.normalize()
          diff.div(d)
          dir.add(diff)
          unless (elem instanceof Cocaine)
            elem.applyForce(diff.normalize())
          n++
      dir.div(n) if (n>0)
      if (0<dir.mag())
        dir.normalize()
        dir.mult(3)
        dir.sub(@v)
        dir.limit(0.1)
      return dir

    align: (group) -> return p.createVector(0,0)

    cohesion: (group) -> return p.createVector(0,0)

  ### `Events`

  These functions are automatic callbacks for `P5.js` events:
  - `p.preload` is called once, immediately before `setup`
  - `p.setup` is called once, at the beginning of execution
  - `p.draw` is called as frequently as `p.framerate`
  - `p.keyPressed` is called on every key input event
  - `p.mousePressed` is called on mouse down
  - `p.windowResized` keeps window full
  - `p.remove` destroys everything in the sketch
  ###
  p.preload = ->
    bg_img = p.loadImage("/rsc/sketch/synapse.png")

  p.setup = ->
    setupDOM()
    p.noStroke()
    p.frameRate(60)

  p.draw = ->
    drawDOM()
    getInput()
    manic = (dope_rate<60)
    drawReceptors()
    dope_rate++ if (dope_rate<60 && p.frameCount%60==0)
    if (p.frameCount%dope_rate==0 && transmitters.length<100)
      n = if (dope_rate<55) then 20 else 5
      for i in [0..rand(2,n)]
        transmitters.push(new Dopamine())
    for dope in transmitters
      dope?.run(transmitters)

  p.keyPressed = ->
    alt = !alt if (p.keyCode is p.ALT)

  p.mouseDragged = ->
    mouse = [p.mouseX,p.mouseY]
    lastMouse = [p.pmouseX,p.pmouseY]

  p.mousePressed = ->
    if (p.width/3<p.mouseX<2*p.width/3)
      if (p.height/3<p.mouseY<2*p.height/3)
        transmitters.unshift(new Cocaine())
    else transmitters.unshift(new Amphetamine())
    dope_rate-- if (dope_rate>30)

  #p.windowResized = ->
  #    p.resizeCanvas(p.windowWidth, p.windowHeight);

  #p.remove = -> p5 = null

  ### Library Functions

  These functions I've included from other files. They're the
  sort of generic utilities that would constitute a library.

  - 'Array::Remove' takes an element out of a standard array
    - `@e`: element to remove
  - `polygon` draws a regular polygon.
    - `@x,@y` \<**int**,**int**\> : center
    - `@r` **int** : radius
    - `@n` **int** : number of points
    - `@o` **real** : offset theta
  ###
  Array::remove = (e) ->
    @[t..t] = [] if (t=@indexOf(e))>-1

  polygon = (x,y,r=1,n=3,o=0) ->
    theta = p.TWO_PI/n
    p.beginShape()
    for i in [0..p.TWO_PI] by theta
      p.vertex(
        x+p.cos(i+o)*r
        y+p.sin(i+o)*r)
    p.endShape(p.CLOSE)

  ### DOM Functions

  These functions initialize and position the DOM objects
  and the main canvas.
  - `setupDOM`: creates DOM objects & canvas
  - `drawDOM`: draws all DOM objects to the canvas
  - `getInput`: collects input data, processes it, and in
    the case of `p.mouseIsPressed`, it calls the mouse
    event callback (otherwise it single-clicks)
  ###
  setupDOM = ->
    canvas = p.createCanvas(756,512)
    canvas.parent('CoffeeSketch')
    canvas.class("entry")
    canvas.style("max-width", "100%")

  drawDOM = ->
    p.clear()
    p.background(bg_img)

  getInput = ->
    mouse = [p.mouseX,p.mouseY]
    lastMouse = [p.pmouseX,p.pmouseY]

  ### Mania Functions

  These functions draw the stars, the planets, and carry out
  the logic of the game / sketch.
  - `drawReceptors`: draws the reuptake receptors on the axon
  ###
  drawReceptors = ->
    p.push()
    p.translate(p.width/2-128,p.height/2-100)
    p.rotate(60)
    p.ellipse(0,0,30,40)
    p.fill(240)
    p.ellipse(10,0,10,30)
    p.ellipse(-10,0,10,30)
    p.pop()
    p.push()
    p.translate(p.width/2+128,p.height/2-100)
    p.rotate(-60)
    p.ellipse(0,0,30,40)
    p.fill(240)
    p.ellipse(10,0,10,30)
    p.ellipse(-10,0,10,30)
    p.pop()
