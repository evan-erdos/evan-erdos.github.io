
# Ben Scott # 2015-10-02 # Literate CoffeeScript Sketch #

### `P5.js` Main class

This is our instance of the main class in the `P5.js` library.
The argument is the link between the library and this code, and
the special functions we override in the class definition are
callbacks for P5.js events.

    myp = new p5 (p)->
        alt = false
        [r_sl,g_sl,b_sl] = [null,null,null]
        [d_sl,s_sl,rand_sl] = [null,null,null]
        mouse = [p.mouseX,p.mouseY]
        lastMouse = [0,0]
        img = null

### `P5.js` Functions ###

These functions are automatic callbacks for `P5.js` events:
- `p.preload` is called once, immediately before `setup`
- `p.setup` is called once, at the beginning of execution
- `p.draw` is called as frequently as `p.framerate`
- `p.keyPressed` is called on every key input event
- `p.remove` destroys everything in the sketch.

        #p.preload = ->
        #    img = loadImage("/rsc/color_palette.png")

        p.setup = ->
            p.createCanvas(p.windowWidth,p.windowHeight)
            p.noStroke()
            p.setupUI()
            p.frameRate(60)

        p.draw = ->
            p.getInput()
            p.drawUI()

        p.keyPressed = ->
            alt = !alt if (p.keyCode is p.ALT)

        #p.remove = -> p5 = null # achieves the same thing

### UI Functions

These functions initialize the DOM objects in the sketch.
@TODO: get a real color picker, not sliders

        p.setupUI = ->
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

        p.drawUI = ->
            p.fill(0)
            p.text("Red",150,16+4)
            p.text("Green",150,32+4)
            p.text("Blue",150,48+4)
            p.text("Size",150,64+4)
            p.text("Delta",150,80+4)
            p.text("Rand",150,96+4)

        ###
        Helper Functions
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

        p.getInput = ->
            mouse = [p.mouseX,p.mouseY]
            p.mousePressed() if (p.mouseIsPressed)

