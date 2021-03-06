---
---

# Ben Scott # 2015-10-02 # CoffeeScript Sketch #

'use strict' # just like JavaScript

### `P5.js` Main class

This is our instance of the main class in the `P5.js` library.
The argument is the link between the library and this code, and
the special functions we override in the class definition are
callbacks for P5.js events.
###
myp = new p5 (p) ->

    ### Input ###
    alt = false
    mouse = [p.mouseX,p.mouseY]
    lastMouse = [p.pmouseX,p.pmouseY]

    ### DOM ###
    [container,canvas] = [null,null]
    [r_sl,g_sl,b_sl] = [null,null,null]
    [d_sl,s_sl,rand_sl] = [null,null,null]

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
    p.setup = ->
        setupCanvas()
        setupDOM()
        p.noStroke()
        p.frameRate(60)

    p.draw = ->
        getInput()
        drawDOM()

    p.keyPressed = ->
        alt = !alt if (p.keyCode is p.ALT)

    p.getInput = ->
        mouse = [p.mouseX,p.mouseY]
        if (p.mouseIsPressed)
            p.mousePressed()

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

    #p.windowResized = -> p.resizeCanvas(p.windowWidth, p.windowHeight);

    #p.remove = -> p5 = null

    ### DOM Functions

    These functions initialize the DOM objects in the sketch.
    - `setupCanvas` creates and positions the main canvas
    - `setupDOM` creates and positions the color sliders
    - `drawDOM` renders the color sliders on every draw
    - `getInput` collects input data, processes it, and in
        the case of `p.mouseIsPressed`, it calls the mouse
        event callback (otherwise it single-clicks)
    ###
    setupCanvas = ->
        container = document.getElementById("CoffeeSketch")
        canvas = p.createCanvas(756,512)
        canvas.parent('CoffeeSketch')
        canvas.class("entry")
        canvas.style("max-width", "100%")

    setupDOM = ->
        writeDOMText("  Red: ")
        r_sl = p.createSlider(0,255,100)
        r_sl.parent('CoffeeSketch')
        writeDOMText("  Green: ")
        g_sl = p.createSlider(0,255,0)
        g_sl.parent('CoffeeSketch')
        writeDOMText("  Blue: ")
        b_sl = p.createSlider(0,255,255)
        b_sl.parent('CoffeeSketch')
        writeDOMText("  Size: ")
        s_sl = p.createSlider(1,8,4)
        s_sl.parent('CoffeeSketch')
        writeDOMText("  Delta: ")
        d_sl = p.createSlider(0,64,32)
        d_sl.parent('CoffeeSketch')
        writeDOMText("  Random: ")
        rand_sl = p.createSlider(0,16,4)
        rand_sl.parent('CoffeeSketch')

    drawDOM = ->
        p.fill(0)
        #p.text("Red",150,16+4)

    writeDOMText = (s) ->
        temp = document.createTextNode(s)
        container.appendChild(temp)

    getInput = ->
        mouse = [p.mouseX,p.mouseY]
        lastMouse = [p.pmouseX,p.pmouseY]
        p.mousePressed() if (p.mouseIsPressed)
