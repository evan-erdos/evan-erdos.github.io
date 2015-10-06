---
---

### Ben Scott # 2015-10-05 # Coffee Rings ###

'use strict'

### `P5.js` Main class

This is our instance of the main class in the `P5.js` library.
The argument is the link between the library and this code, and
the special functions we override in the class definition are
callbacks for P5.js events.
###
myp = new p5 (p)->
    alt = false
    pi = p.PI

    [planet_img,sun_img,ring_img] = [null,null,null]

    ### DOM ###
    [r_sl,g_sl,b_sl] = [null,null,null]
    [d_sl,s_sl,rand_sl] = [null,null,null]

    ### Audio ###
    [input,analyzer,volume] = [null,null,null]

    ### Input ###
    mouse = [p.mouseX,p.mouseY]
    lastMouse = [p.pmouseX,p.pmouseY]

    ### `Planet`

    This is a class which represents planets.
    - `@x,@y`: center
    - `@r`: radius of the planet
    - `@hasRing`: planet has rings
    ###
    class Planet
        r_ring: 1

        constructor: (@x=0,@y=0,@r=1,@hasRing=false) ->
            @r_ring = @r+50 if @hasRing
        #draw: ->

    ### `Events`

    These functions are automatic callbacks for `P5.js` events:
    - `p.preload` is called once, immediately before `setup`
    - `p.setup` is called once, at the beginning of execution
    - `p.draw` is called as frequently as `p.framerate`
    - `p.keyPressed` is called on every key input event
    - `p.mousePressed` is called on mouse down
    - `p.remove` destroys everything in the sketch
    ###
    p.preload = ->
        palette_img = p.loadImage("/rsc/colormap.gif")
        planet_img = p.loadImage("/rsc/planet.png")
        sun_img = p.loadImage("/rsc/sun.png")
        #ring_img = p.loadImage("/rsc/ring.png")

    p.setup = ->
        p.createCanvas(p.windowWidth,p.windowHeight, p.WEBGL)
        p.noStroke()
        #p.setupDOM()
        #p.setupAudio()
        p.setupWebGL()
        p.frameRate(60)

    p.setupAudio = ->
        mic = new p5.AudioIn()
        mic.start()

    p.draw = ->
        p.background(120)
        p.HexGrid(128,128)
        p.getInput()
        #p.drawDOM()
        p.renderWebGL()

    p.keyPressed = ->
        alt = !alt if (p.keyCode is p.ALT)

    ###
    p.mousePressed = ->
        s = s_sl.value()
        [x,y] = [16*s,16*s]
        d = d_sl.value()
        rgb = p.color(
            r_sl.value()+p.random(d)
            g_sl.value()+p.random(d)
            b_sl.value()+p.random(d),127)
        rand = rand_sl.value()
        delta_size = p.random(s/2)
        if (alt) then p.fill(255)
        else p.fill(rgb)
        p.ellipse(
            mouse[0]+p.random(-rand,rand)
            mouse[1]+p.random(-rand,rand)
            x*delta_size,y*delta_size)
    ###

    #p.remove = -> p5 = null

    ### Library Functions

    These functions I've included from other files. They're the
    sort of generic utilities that would constitute a library.

    - `p.polygon` draws a regular polygon.
      - @x,@y: center
      - @r: radius
      - @n: number of points
      - @o: offset theta
    - `p.HexGrid` draws a grid of hexagons.
      - @x,@y: center
      - @r: radius
      - @s: size
    ###
    p.polygon = (x,y,r=1,n=3,o=0) ->
        theta = p.TWO_PI/n
        p.beginShape()
        for i in [0..p.TWO_PI] by theta
            p.vertex(x+p.cos(i+o)*r, y+p.sin(i+o)*r)
        p.endShape(p.CLOSE)

    p.HexGrid = (x=0,y=0,r=32,s=16) ->
        [pi_3,pi_6,h] = [p.PI/3, p.PI/6, p.sqrt(3)/2]
        for i in [0..s]
            for j in [0..s/4]
                if p.random(4)>3
                    p.fill(p.random(255))
                else p.fill(255)
                p.polygon(
                    x+(i*(h)*r*p.cos(pi_3))*2
                    y+(3.45*j*h*r)+((i%2)*(h)*r*p.sin(pi_3))*2
                    r, 6, pi_6)

    ### DOM Functions

    These functions initialize the DOM objects in the sketch.
    - `p.setupDOM` creates and positions the color sliders
    - `p.drawDOM` renders the color sliders on every draw
    - `p.getInput` collects input data, processes it, and in
        the case of `p.mouseIsPressed`, it calls the mouse
        event callback (otherwise it single-clicks)
    ###
    p.setupDOM = ->
        r_sl = p.createSlider(0,255,100)
        r_sl.position(16,16)
        g_sl = p.createSlider(0,255,0)
        g_sl.position(16,32)
        b_sl = p.createSlider(0,255,255)
        b_sl.position(16,48)
        s_sl = p.createSlider(1,8,4)
        s_sl.position(16,64)
        d_sl = p.createSlider(0,64,32)
        d_sl.position(16,80)
        rand_sl = p.createSlider(0,16,4)
        rand_sl.position(16,96)

    p.drawDOM = ->
        p.fill(0)
        p.text("Red",150,16+4)
        p.text("Green",150,32+4)
        p.text("Blue",150,48+4)
        p.text("Size",150,64+4)
        p.text("Delta",150,80+4)
        p.text("Rand",150,96+4)
        p.image(palette_img)

    p.getInput = ->
        mouse = [p.mouseX,p.mouseY]
        #p.mousePressed() if (p.mouseIsPressed)

    p.setupWebGL = ->
        p.translate(0,2,0)

    p.renderWebGL = ->
        p.background(0)
        p.translate(0,100,0)

        p.pointLight(0,0,0,0,0,0)
        p.texture(sun_img)
        p.rotateY(-p.frameCount * 0.005)
        p.sphere(200)
        p.rotateZ(0.5)
        p.rotateY(p.frameCount * 0.01)
        p.translate(0,0,500)

        #p.texture(ring_img)
        #p.rotateZ(90)
        #p.plane(100, 100)
        p.texture(planet_img)
        p.sphere(50)

