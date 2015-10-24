---
layout: sketch
title: Random Universe
tag: [Programming, GameDev]
permalink: /sketch/smile_drive.coffee/
script: smile_drive
---

Space is neat. WebGL is neater. Once in ~20 runs, you will generate a binary star with this program (keep clicking).

The code below is sloppy and not as well documented as the previous few. I left some code to generate a hexagonal grid in there while testing to see if I could integrate the WebGL side with the usual P5.js part, and I couldn't. This *was* named smile drive because I was going to have a spaceship, and then have it thrust based upon if the camera recorded if the user was smiling or not. The silly text above would have made sense if I had that running. Anyways, click on it or click on the image below to look around in the universe.

The most interesting code examples are probably the recursive planet drawing in the planet class and the perlin noise stars at the end.


### `P5.js` Main class ###

This is our instance of the main class in the `P5.js` library. The argument is the link between the library and this code, and the special functions we override in the class definition are callbacks for P5.js events.

```coffee
### Ben Scott # 2015-10-12 # Random Universe ###

'use strict' # just like JavaScript

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
    [r_sl,g_sl,b_sl] = [null,null,null]
    [d_sl,s_sl,rand_sl] = [null,null,null]

    ### Audio ###
    [mic,analyzer,volume] = [null,null,0]
```


### `Planet` ###

This is a class which represents planets. If no arguments are passed to it, it makes a random planet, with random attributes. A planet of sufficient size turns into a gas giant, while smaller planets look whiter. Moons are added recursively, and are also drawn as such, taking their proper orbit.

- `@r` **int** : body radius
- `@dist` **int** : orbital radius
- `@ot` **real** : orbit time
- `@dt` **real** : day period
- `@z` **real** : z-offset
- `@moons` **Planet[]** : list of other planets
- `@img` **Image** : image to render onto the planet

```coffee
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
```


### `Sun` ###

This is a class which represents the sun. I'd like to have it inherit from planet (or vice versa) but that seems to cause problems. Every once in awhile, you will get a binary star. Uncommenting the one line will cause it to always be a binary star.

- `@r` **int** : body radius
- `@dt` **real** : day period
- `@ot` **real** : orbit time
- `@img` **Image** : texture for the sun

```coffee
class Sun
    @isBinaryStar = false
    constructor: (@r,@dt=0.1,@ot=0.05,@img) ->
        @r+=(p.random(-150,150)) if (@r>=300)
        if (@r<=1000) then @img = sun_img else @img = blue_img
        #@isBinaryStar = true # to get binary each time
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
```


### `Events` ###

These functions are automatic callbacks for `P5.js` events:

- `p.preload` is called once, immediately before `setup`
- `p.setup` is called once, at the beginning of execution
- `p.draw` is called as frequently as `p.framerate`
- `p.keyPressed` is called on every key input event
- `p.mousePressed` is called on mouse down
- `p.remove` destroys everything in the sketch


```coffee
	p.preload = ->
        palette_img = p.loadImage("/rsc/colormap.gif")
        sun_img = p.loadImage("/rsc/sun.png")
        blue_img = p.loadImage("/rsc/blue_sun.png")
        planet_img = p.loadImage("/rsc/planet.png")
        gas_img = p.loadImage("/rsc/gas_giant.png")
        rock_img = p.loadImage("/rsc/rock.png")

    p.setup = ->
        setupCanvas()
        p.noStroke()
        #p.setupDOM()
        #setupAudio()
        setupWebGL()
        p.frameRate(60)

    p.draw = ->
        #p.background(120)
        #HexGrid(128,128)
        getInput()
        #getAudio()
        #p.drawDOM()
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

    p.windowResized = ->
        p.resizeCanvas(p.windowWidth, p.windowHeight);

    #p.remove = -> p5 = null
```


### Library Functions ###

These functions I've included from other files. They're the sort of generic utilities that would constitute a library.

- `polygon` draws a regular polygon.
  - `@x,@y` **int,int** : center
  - `@r` **int** : radius
  - `@n` **int** : number of points
  - `@o` **real** : offset theta

- `HexGrid` draws a grid of hexagons.
  - `@x,@y` **int,int** : center
  - `@r` **int** : radius
  - `@s` **int** : size

```coffee
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
```


### Audio Functions ###

These functions deal with audio input:

- `setupAudio` initializes audio system
- `getAudio` gets the volume, maps it to the sun

```coffee
    setupAudio = ->
        mic = new p5.AudioIn()
        mic.start()

    getAudio = ->
        raw_volume = p.abs(mic.getLevel())
        volume = ((raw_volume-volume)/2)%10
        if volume>0.001 then sun_r_base+=5 else sun_r_base-=2
        sun_r = p.max(150,sun_r_base)+p.map(volume,0,1,0,300)
```


### DOM Functions ###

These functions initialize the DOM objects in the sketch:

- `setupDOM` creates and positions DOM elements and the canvas
- `drawDOM` renders the DOM elements (called from `p.draw`)
- `getInput` collects input data

```coffee
    setupDOM = ->
        canvas = p.createCanvas(756,512,p.WEBGL)
        canvas.parent('CoffeeSketch')
        canvas.class("entry")
        canvas.style("max-width", "100%")
        #rand_sl = p.createSlider(0,16,4)
        #rand_sl.position(16,96)

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

        p.camera(cam_pos[0],cam_pos[1],cam_pos[2])

        ### for arrow key steering
        if (key.up || key.down || key.left || key.right)
            if (key.up || key.down)
                cam_pos[1]-=10 if key.up
                cam_pos[1]+=10 if key.down

            if (key.left || key.right)
                cam_pos[0]-=10 if key.left
                cam_pos[0]+=10 if key.right

        #p.camera(cam_pos[0],cam_pos[1],cam_pos[2])
        ###
```

### WebGL Functions ###

WebGL defers rendering to the system's GPU. Neat, huh?

- `setupWebGL` creates WebGL objects
- `drawWebGL` renders the WebGL objects

```coffee
    setupWebGL = ->
        setupPlanets()
        setupStars()

    drawWebGL = ->
        p.background(0)
        p.translate(0,100,0)
        p.pointLight(250,250,250,1,0,0,0)
        drawStars()
        sun.draw()
        drawPlanets()
```

### Random Universe Functions ###

These functions draw the stars, the planets, and carry out the logic of the game / sketch.

- `setupStars`: initializes a random array of stars
- `setupPlanets`: initializes an array of planets
- `drawStars`: renders the stars as planes
- `drawPlanets`: renders the planets

```coffee
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
        xoff = 0
        p.ambientMaterial(255,255,255)
        for i in [0..n_stars]
            xoff+=0.1
            p.push()
            p.translate(
                arr_stars[i][0]
                arr_stars[i][1],-10000)
            p.plane(20*p.noise(xoff),20*p.noise(xoff))
            p.pop()

    drawPlanets = ->
        planet.draw() for planet in planets
```

