---
---

### Ben Scott # 2015-10-07 # Solar System ###

'use strict' # just like JavaScript

### `P5.js` Main class

This is our instance of the main class in the `P5.js` library.
The argument is the link between the library and this code, and
the special functions we override in the class definition are
callbacks for P5.js events.
###
myp = new p5 (p) ->

    ### Constants ###
    [pi,pi_3,pi_6] = [p.PI,p.PI/3,p.PI/6]

    ### Input ###
    alt = false
    mouse = [p.mouseX,p.mouseY]
    lastMouse = [p.pmouseX,p.pmouseY]
    key =
        up: false
        down: false
        left: false
        right: false

    ### WebGL ###
    [sun_img,planet_img,sky_img] = [null,null,null]

    [sun,sun_r,sun_r_base] = [null,50,150]
    cam_pos = [0,0,1000]
    planets = []

    n_stars = 1024
    arr_stars = []

    ### DOM ###
    [r_sl,g_sl,b_sl] = [null,null,null]
    [d_sl,s_sl,rand_sl] = [null,null,null]

    ### Audio ###
    [mic,analyzer,volume] = [null,null,0]

    ### `Planet`

    This is a class which represents planets.
    - `@r`: body radius
    - `@o`: orbital radius
    - `@dt`: day period
    - `@ot`: orbit time
    - `@img`: surface image reference
    ###
    class Planet
        constructor: (@r=1,@o,@dt=0.1,@ot=0.05,@img) ->
            @img = planet_img if @img==null

        draw: ->
            p.push()
            p.rotateZ(0.375)
            p.rotateY(p.frameCount * 0.01)
            #p.translate(0,0,@ot)
            p.texture(@img) if @img?
            p.sphere(@r)
            p.pop()

        burn: ->
            @img = sun_img


    ### `Sun`

    This is a class which represents the sun. I'd like to have
    it inherit from planet (or vice versa) but that seems to
    cause problems.
    - `@r`: body radius
    - `@dt`: day period
    - `@ot`: orbit time
    - `@img`: texture for the sun
    ###
    class Sun
        constructor: (@r,@dt=0.1,@ot=0.05,@img) ->
            @img = sun_img if @img==null

        draw: ->
            p.push()
            p.texture(sun_img)
            p.rotateY(p.frameCount * 0.005)
            p.sphere(@r)
            p.rotateY(p.frameCount * @dt)
            p.pop()

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
        #sky_img = p.loadImage("/rsc/stars.png")
        #ring_img = p.loadImage("/rsc/ring.png")

    p.setup = ->
        p.createCanvas(p.windowWidth,p.windowHeight, p.WEBGL)
        p.noStroke()
        #p.setupDOM()
        #setupAudio()
        setupWebGL()
        p.frameRate(60)

    p.draw = ->
        #p.background(120)
        #p.HexGrid(128,128)
        getInput()
        #getAudio()
        #p.drawDOM()
        renderWebGL()

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
    polygon = (x,y,r=1,n=3,o=0) ->
        theta = p.TWO_PI/n
        p.beginShape()
        for i in [0..p.TWO_PI] by theta
            p.vertex(x+p.cos(i+o)*r, y+p.sin(i+o)*r)
        p.endShape(p.CLOSE)

    HexGrid = (x=0,y=0,r=32,s=16) ->
        h = p.sqrt(3)/2
        for i in [0..s]
            for j in [0..s/4]
                if p.random(4)>3
                    p.fill(p.random(255))
                else p.fill(255)
                p.polygon(
                    x+(i*(h)*r*p.cos(pi_3))*2
                    y+(3.45*j*h*r)+((i%2)*(h)*r*p.sin(pi_3))*2
                    r, 6, pi_6)


    ### Audio Functions

    These functions deal with audio input.
    - `p.setupAudio` initializes audio system
    - `p.getAudio` gets the volume, maps it to the sun
    ###
    setupAudio = ->
        mic = new p5.AudioIn()
        mic.start()

    getAudio = ->
        raw_volume = p.abs(mic.getLevel())
        volume = ((raw_volume-volume)/2)%10
        if volume>0.001 then sun_r_base+=5 else sun_r_base-=2
        sun_r = p.max(150,sun_r_base) + p.map(volume,0,1,0,300)
        burnPlanets(sun_r)

    ### DOM Functions

    These functions initialize the DOM objects in the sketch.
    - `p.setupDOM` creates and positions the color sliders
    - `p.drawDOM` renders the color sliders on every draw
    - `p.getInput` collects input data, processes it, and in
        the case of `p.mouseIsPressed`, it calls the mouse
        event callback (otherwise it single-clicks)
    ###
    setupDOM = ->
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

    drawDOM = ->
        p.fill(0)
        p.text("Red",150,16+4)
        p.text("Green",150,32+4)
        p.text("Blue",150,48+4)
        p.text("Size",150,64+4)
        p.text("Delta",150,80+4)
        p.text("Rand",150,96+4)
        p.image(palette_img)

    getInput = ->
        mouse = [p.mouseX,p.mouseY]
        lastMouse = [p.pmouseX,p.pmouseY]
        #p.mousePressed() if (p.mouseIsPressed)

        key.up = (p.keyCode is p.UP_ARROW)
        key.down = (p.keyCode is p.DOWN_ARROW)
        key.left = (p.keyCode is p.LEFT_ARROW)
        key.right = (p.keyCode is p.RIGHT_ARROW)

        if (key.up || key.down)
            cam_pos[2]-=5 if key.up
            cam_pos[2]+=5 if key.down

        if (key.left || key.right)
            cam_pos[0]-=5 if key.left
            cam_pos[0]+=5 if key.right

        p.camera(cam_pos[0],cam_pos[1],cam_pos[2])

    ### WebGL Functions

    WebGL defers rendering to the system's GPU. Neat, huh?
    - `setupWebGL` creates WebGL objects
    - `renderWebGL` renders the WebGL objects
    ###
    setupWebGL = ->
        sun = new Sun(150,-0.005,-0.5)
        planets = [
            new Planet(300,0,20,0.01,-0.2,planet_img)
            new Planet(200,200,100,-0.005,-0.5)]
        p.translate(0,2,0)
        setupStars()

    renderWebGL = ->
        p.background(0)
        p.translate(0,100,0)
        p.pointLight(250,250,250,1,0,0,0)
        drawStars()
        sun.draw()
        drawPlanets()

    ### Domain Functions

    These functions draw the stars, the planets, and carry out
    the logic of the game / sketch.
    - `setupStars`: initializes a random array of stars
    - `drawStars`: renders the stars as planes
    - `setupPlanets`: initializes an array of planets
    - `drawPlanets`: renders the planets
    - `burnPlanets`: sets the planet teture to that of the sun
        if the sun engulfs it.
    ###
    setupStars = ->
        xoff = 0
        [x,y] = [2048,2048]
        for i in [0..n_stars/2]
            xoff+=0.01
            arr_stars.push(
                [[(x-p.noise(xoff)*x*2)*10]
                 [(y-p.random(y*2))*10]])
        for i in [0..n_stars/2]
            arr_stars.push(
                [[(2*x-p.random(x*4))*10]
                 [(2*y-p.random(y*4))*10]])

    drawStars = ->
        for i in [0..n_stars]
            p.push()
            p.translate(
                arr_stars[i][0]
                arr_stars[i][1], -10000)
            p.plane(10,10)
            p.pop()

    setupPlanets = ->
        planets = [
            new Planet(-0.2,-0.05,250,40)
            new Planet(0.5,0.01,600,50)]

    drawPlanets = ->
        drawPlanet(-0.2,-0.05,250,40)
        startPlanetSet(0.5,0.01,700,50)
        drawPlanet(0,-0.1,125,10)
        endPlanetSet(0,-0.05,100,5)
        #for planet in planets
        #    p.translate(0,0,planet.ot)
        #    planet.draw()

    burnPlanets = (r) ->
        for planet in planets
            planet.burn() if (planet.ot<r)

    startPlanetSet = (z,orbit,dist,radius) ->
        p.push()
        rawPlanet(z,orbit,dist,radius)

    endPlanetSet = (z,orbit,dist,radius) ->
        rawPlanet(z,orbit,dist,radius)
        p.pop()

    rawPlanet = (z,orbit,dist,radius) ->
        p.rotateZ(z)
        p.rotateY(p.frameCount * orbit)
        p.translate(0,0,dist)
        p.push()
        p.rotateY(p.frameCount * 0.2)
        p.texture(planet_img)
        p.sphere(radius)
        p.pop()

    drawPlanet = (z,orbit,dist,radius) ->
        p.push()
        rawPlanet(z,orbit,dist,radius)
        p.pop()

### WebGL `Point`

A 3D point class, for use with WebGL
- `@x,@y,@z`: coordinates
###
class Point
    constructor: (@x=0,@y=0,@z=0) ->


