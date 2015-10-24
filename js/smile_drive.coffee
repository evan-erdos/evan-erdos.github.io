---
---

### Ben Scott # 2015-10-12 # Smile Drive ###

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
    [sun_img,blue_img] = [null,null]
    [planet_img,gas_img,rock_img] = [null,null,null]
    [sun,sun_r,sun_r_base] = [null,50,150]
    cam_pos = [0,0,5000]
    planets = []

    n_stars = 1024
    arr_stars = []

    ### DOM ###
    [container,canvas] = [null,null]
    [r_sl,g_sl,b_sl] = [null,null,null]
    [d_sl,s_sl,rand_sl] = [null,null,null]

    ### Audio ###
    [mic,analyzer,volume] = [null,null,0]

    ### `Planet`

    This is a class which represents planets.
    - `@r` **int** : body radius
    - `@dist` **int** : orbital radius
    - `@ot` **real** : orbit time
    - `@dt` **real** : day period
    - `@z` **real** : z-offset
    - `@moons` **Planet[]** : list of other planets
    - `@img` **Image** : image to render onto the planet
    ###
    class Planet
        @moons = []
        @img = null
        constructor: (@r=-1,@dist,@ot,@dt,@z) ->
            @makeRandomPlanet() if (@r<0)
            if (60<=@r<=150)
                @img = rock_img
            else if (@r>150)
                @img = gas_img
            else @img = planet_img
            @moons = new Array()

        draw: ->
            p.push()
            p.rotateZ(@z)
            p.rotateY(p.frameCount*@ot)
            p.translate(0,0,@dist)
            p.push()
            p.rotateY(p.frameCount*@dt)
            p.texture(@img)
            p.sphere(@r)
            @drawMoons()
            p.pop()
            p.pop()

        drawMoons: ->
            return if (@moons==undefined)
            for moon in @moons
                moon.draw()

        addMoon: (moon) ->
            return if (@moons==undefined)
            @moons.push(moon)

        makeRandomPlanet: ->
            @r = p.random(10,200)
            @dist = p.random(1500,15000)
            @ot = p.random(0.0005,0.05)
            @dt = p.random(0.001,0.5)
            @z = p.random(-0.5,0.5)
            if (p.random(10)>7)
                for i in [0..p.random(3)]
                    @addMoon(new Planet(
                        p.random(15)
                        p.random(@r+20,@r+200)
                        p.random(0.05)
                        p.random()
                        p.random(-0.05,0.05)))

    ### `Sun`

    This is a class which represents the sun. I'd like to have
    it inherit from planet (or vice versa) but that seems to
    cause problems.
    - `@r` **int** : body radius
    - `@dt` **real** : day period
    - `@ot` **real** : orbit time
    - `@img` **Image** : texture for the sun
    ###
    class Sun
        @isBinaryStar = false
        constructor: (@r,@dt=0.1,@ot=0.05,@img) ->
            @r+=(p.random(-150,150)) if (@r>=300)
            if (@r<=1000) then @img = sun_img else @img = blue_img
            @isBinaryStar = (p.random(100)>95)

        draw: ->
            p.push()
            p.texture(@img)
            p.rotateY(240)
            unless (@isBinaryStar)
                p.rotateY(p.frameCount*0.005)
                p.sphere(@r)
                p.rotateY(p.frameCount * @dt)
            else @drawBinaryStar()
            p.pop()

        drawBinaryStar: ->
            p.rotateX(p.frameCount*0.5)
            p.rotateY(p.frameCount*0.5)
            p.rotateZ(p.frameCount*0.5)
            p.push()
            p.basicMaterial(250,250,255)
            p.translate(0,-@r/4,-@r/4)
            p.sphere(@r/2)
            p.pop()
            p.push()
            p.basicMaterial(255,255,250)
            p.translate(0,@r/4,@r/4)
            p.sphere(@r/2)
            p.pop()


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
        sun_img = p.loadImage("/rsc/sketch/sun.png")
        blue_img = p.loadImage("/rsc/sketch/blue_sun.png")
        planet_img = p.loadImage("/rsc/sketch/planet.png")
        gas_img = p.loadImage("/rsc/sketch/gas_giant.png")
        rock_img = p.loadImage("/rsc/sketch/rock.png")

    p.setup = ->
        canvas = p.createCanvas(756,512,p.WEBGL)
        canvas.parent('CoffeeSketch')
        canvas.class("entry")
        canvas.style("max-width", "100%")
        p.noStroke()
        #setupDOM()
        #setupAudio()
        setupWebGL()
        p.frameRate(60)

    p.draw = ->
        #p.background(120)
        #HexGrid(128,128)
        getInput()
        #getAudio()
        #drawDOM()
        drawWebGL()

    p.keyPressed = ->
        alt = !alt if (p.keyCode is p.ALT)

    p.mouseDragged = ->
        mouse = [p.mouseX,p.mouseY]
        lastMouse = [p.pmouseX,p.pmouseY]
        cam_pos[0]-= (mouse[0]-lastMouse[0])*8
        cam_pos[1]-= (mouse[1]-lastMouse[1])*8

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

    #p.windowResized = -> p.resizeCanvas(p.windowWidth, p.windowHeight);

    #p.remove = -> p5 = null

    ### Library Functions

    These functions I've included from other files. They're the
    sort of generic utilities that would constitute a library.

    - `polygon` draws a regular polygon.
      - `@x,@y` \<**int**,**int**\> : center
      - `@r` **int** : radius
      - `@n` **int** : number of points
      - `@o` **real** : offset theta
    - `HexGrid` draws a grid of hexagons.
      - `@x,@y` \<**int**,**int**\> : center
      - `@r` **int** : radius
      - `@s` **int** : size
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
                    x+(i*h*r*p.cos(pi_3))*2
                    y+(3.45*j*h*r)+((i%2)*h*r*p.sin(pi_3))*2
                    r, 6, pi_6)


    ### Audio Functions

    These functions deal with audio input.
    - `setupAudio` initializes audio system
    - `getAudio` gets the volume, maps it to the sun
    ###
    setupAudio = ->
        mic = new p5.AudioIn()
        mic.start()

    getAudio = ->
        raw_volume = p.abs(mic.getLevel())
        volume = ((raw_volume-volume)/2)%10
        if volume>0.001 then sun_r_base+=5 else sun_r_base-=2
        sun_r = p.max(150,sun_r_base)+p.map(volume,0,1,0,300)

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
        canvas = p.createCanvas(756,512,p.WEBGL)
        canvas.parent('CoffeeSketch')
        canvas.class("entry")
        canvas.style("max-width", "100%")

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

    getInput = ->
        mouse = [p.mouseX,p.mouseY]
        lastMouse = [p.pmouseX,p.pmouseY]
        #p.mousePressed() if (p.mouseIsPressed)

        key.up = (p.keyCode is p.UP_ARROW)
        key.down = (p.keyCode is p.DOWN_ARROW)
        key.left = (p.keyCode is p.LEFT_ARROW)
        key.right = (p.keyCode is p.RIGHT_ARROW)

        p.camera(cam_pos[0],cam_pos[1],cam_pos[2])

    ### WebGL Functions

    WebGL defers rendering to the system's GPU. Neat, huh?
    - `setupWebGL` creates WebGL objects
    - `drawWebGL` renders the WebGL objects
    ###
    setupWebGL = ->
        setupPlanets()
        setupStars()

    drawWebGL = ->
        p.background(0)
        p.translate(0,100,0)
        drawStars()
        sun.draw()
        drawPlanets()

    ### Domain Functions

    These functions draw the stars, the planets, and carry out
    the logic of the game / sketch.
    - `setupStars`: initializes a random array of stars
    - `setupPlanets`: initializes an array of planets
    - `drawStars`: renders the stars as planes
    - `drawPlanets`: renders the planets
    ###
    setupStars = ->
        n = 0
        [x,y] = [2048,2048]
        for i in [0..n_stars/2]
            n+=0.01
            arr_stars.push(
                [[(x-p.noise(n)*x*2)*10]
                 [(y-p.random(y*2))*10]])
        for i in [0..n_stars/2]
            arr_stars.push(
                [[(2*x-p.random(x*4))*10]
                 [(2*y-p.random(y*4))*10]])

    setupPlanets = ->
        sun = new Sun(1000,-0.005,-0.5)
        planets = [
            new Planet(64,10000,0.01,0.02,0.02)
            new Planet(10,5000,0.01,0,0.05)
            new Planet(25,15000,-0.01,0.2,0.1)
            new Planet(30,20000,-0.005,0,0.1)
            new Planet(8,7000,0.02,-0.05,-0.2)
            new Planet(160,12000,-0.005,-0.03,-0.2)]
        planets[0].addMoon(new Planet(10,150,-0.1,0,0.2))
        planets[0].addMoon(new Planet(5,125,-0.05,0,0.1))
        planets[5].addMoon(new Planet(30,400,-0.1,0.1,0.2))
        planets[5].addMoon(new Planet(10,300,0.1,0.1,0.2))
        for i in [0..p.random(10)]
            planets.push(new Planet())

    drawStars = ->
        n = 0
        p.basicMaterial(255)
        for i in [0..n_stars]
            n+=0.1
            p.push()
            p.translate(
                arr_stars[i][0]
                arr_stars[i][1],-10000)
            p.plane(20*p.noise(n),20*p.noise(n))
            p.pop()

    drawPlanets = ->
        planet.draw() for planet in planets

### WebGL `Point`

A 3D point class, for use with WebGL
- `@x,@y,@z`: coordinates
###
class Point
    constructor: (@x=0,@y=0,@z=0) ->


