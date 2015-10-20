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

    ### DOM ###
    [container,canvas] = [null,null]

    ### Resources ###
    [bg_img,dope_img] = [null,null]

    ### Domain ###
    dope_rate = 60
    manic = false
    neurotransmitters = []
    receptors = []
    uptake_0 = p.createVector(p.width/2,p.height/2)
    uptake_1 = p.createVector(0,0)

    ### `Dopamine`

    This is a class which represents the neurotransmitter
    Dopamine, which is responsible for pleasure and euphoria.
    - `@a`: acceleration
    - `@v`: velocity
    - `@m`: mass
    - `@max_v`: maximum speed
    - `@max_f`: maximum force
    - `@r`: radius
    - `@pos`: current position
    - `@tgt`: target position
    ###
    class Dopamine
        max_v = 3
        max_f = 0.05
        @tgt = null
        @lifespan = 360

        constructor: (@r=10,@pos,@m=1,@lifespan=1024) ->
            @a = p.createVector(0,0)
            @v = p.createVector(p.random(-1,1),p.random(-1,1))
            @tgt = p.createVector(p.width/2,p.height/2)
            if (@pos==null || @pos==undefined)
                @pos = p.createVector(
                    p.width/2+p.random(-50,50),-10)
                @v.y = p.random(1,2)

        run: (group) ->
            @flock(group)
            @update()
            @bounds()
            @draw()

        applyForce: (f) -> @a.add(f)/@m

        flock: (group) ->
            sep = @separate(group)
            ali = @align(group)
            coh = @cohesion(group)
            final_steer = @seek(p.createVector(p.width/2,p.height*2))

            sep.mult(1.5)
            ali.mult(1)
            coh.mult(1)
            final_steer.mult(0.5)

            @applyForce(sep)
            @applyForce(ali)
            @applyForce(coh)
            @applyForce(final_steer)

        bounds: ->
            unless (-20<@pos.x<p.width+20 && -20<@pos.y<p.height+20)
                neurotransmitters.remove(this)
                delete this

        update: ->
            @v.add(@a)
            @v.limit(max_v)
            @pos.add(@v)
            @a = p.createVector(0,0)

        seek: (tgt) ->
            @tgt = tgt
            len = p5.Vector.sub(tgt,@pos)
            len.normalize()
            len.mult(max_v)
            dir = p5.Vector.sub(len,@v)
            dir.limit(0.05)
            return dir

        draw: ->
            p.push()
            value = p.map(value,0,255,60,120)
            p.fill(value,180,180)
            p.stroke(180)
            p.strokeWeight(2)
            p.translate(p.random(3),p.random(3)) if (manic)
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
    - `@a`: acceleration
    - `@v`: velocity
    - `@max_v`: maximum speed
    - `@max_f`: maximum force
    - `@r`: radius
    - `@pos`: current position
    - `@tgt`: target position
    ###
    class Cocaine extends Dopamine
        @n_tgt = null
        @lifespan = 512

        constructor: ->
            super
            #@tgt = if (p.random(0,1)>0) then uptake_0 else uptake_1
            @lifespan = 512+p.random(-128,128)
            @mass = 3
            #p.height/2+p.random(-25,25))
            @n_tgt = p.createVector(
                p.width/2+p.random(-128,128)
                p.height/2+p.random(-50,50))

        update: ->
            super
            @lifespan--
            #console.log("#{@lifespan}")
            if (@lifespan<0)
                @applyForce(@seek(p.createVector(
                    p.width*2, p.random(-30,30))).mult(3))

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
            #p.ellipse(@pos.x,@pos.y,@r,@r)
            #p.line(@pos.x,@pos.y,@tgt.x,@tgt.y)
            p.pop()

        flock: (group) ->
            sep = @separate(group)
            ali = @align(group)
            coh = @cohesion(group)

            sep.mult(1)
            ali.mult(1)
            coh.mult(1)

            @applyForce(sep)
            @applyForce(ali)
            @applyForce(coh)
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
                    #console.log(elem instanceof Cocaine)
                    unless (elem instanceof Cocaine)
                        elem.applyForce(diff.normalize())
                    n++
            dir.div(n) if (n>0)
            if (0<dir.mag())
                dir.normalize()
                dir.mult(3)
                dir.sub(@v)
                dir.limit(0.05)
            return dir

    ### `Amphetamine`

    The same neuron! Now with amphetamines! Amphetamines act
    as a releasing agent for dopamine, and are much easier
    to animate!
    - `@a`: acceleration
    - `@v`: velocity
    - `@max_v`: maximum speed
    - `@max_f`: maximum force
    - `@r`: radius
    - `@pos`: current position
    - `@tgt`: target position
    ###
    class Amphetamine extends Dopamine
        @n_tgt = null

        constructor: ->
            super
            @n_tgt = p.createVector(
                p.width/2-128+p.random(-2,2)
                p.height/2-100+p.random(-2,2))
            if (p.random(3)>1)
                @n_tgt = p.createVector(
                    p.width/2+128+p.random(-2,2)
                    p.height/2-100+p.random(-2,2))

        update: ->
            super
            @lifespan--
            #console.log("#{@lifespan}")
            if (@lifespan<0)
                if (p.random(2)>1)
                    @applyForce(@seek(p.createVector(
                        p.width*2, p.random(-30,30))).mult(3))
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
            sep = @separate(group)
            ali = @align(group)
            coh = @cohesion(group)

            sep.mult(1)
            ali.mult(0)
            coh.mult(0)

            @applyForce(sep)
            @applyForce(ali)
            @applyForce(coh)
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
                    #console.log(elem instanceof Cocaine)
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

    ### `Receptor`

    This is a class to represent dopamine receptors in the synapse.
    - `@pos`: current position
    - `@theta`: current rotation
    ###
    class Receptor

        constructor: (@pos,@theta=0) ->

        draw: ->
            p.push()
            p.fill(0)
            #p.rotate(@theta/p.HALF_PI)
            p.ellipse(@pos.x-10,@pos.y-10,@pos.x+10,@pos+10)
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
        bg_img = p.loadImage("/rsc/sketch/synapse.png")

    p.setup = ->
        setupCanvas()
        p.noStroke()
        #setupDOM()
        p.frameRate(60)
        receptors.push(new Receptor(p.createVector(p.width/2,p.height/2)))

    p.draw = ->
        p.clear()
        p.background(bg_img)
        getInput()
        manic = (dope_rate<60)
        drawReceptors()
        if (dope_rate<60 && p.frameCount%90==0)
            dope_rate++
        if (p.frameCount%dope_rate==0 && neurotransmitters.length<100)
            n = if (dope_rate<55) then 30 else 5
            for i in [0..p.random(2,n)]
                neurotransmitters.push(new Dopamine())
        for dope in neurotransmitters
            unless dope==null || dope==undefined
                dope.run(neurotransmitters)
        #drawDOM()

    p.keyPressed = ->
        alt = !alt if (p.keyCode is p.ALT)

    p.mouseDragged = ->
        mouse = [p.mouseX,p.mouseY]
        lastMouse = [p.pmouseX,p.pmouseY]

    p.mousePressed = ->
        pos = p.createVector(p.mouseX,p.mouseY)
        neurotransmitters.unshift(
            new Amphetamine(10,pos,p.createVector(0,0)))
        dope_rate--

    #p.windowResized = -> p.resizeCanvas(p.windowWidth, p.windowHeight);

    #p.remove = -> p5 = null

    ### Library Functions

    These functions I've included from other files. They're the
    sort of generic utilities that would constitute a library.

    - 'Array::Remove' takes an element out of a standard array
      - `@e`: element to remove
    - `polygon` draws a regular polygon.
      - @x,@y: center
      - @r: radius
      - @n: number of points
      - @o: offset theta
    - `HexGrid` draws a grid of hexagons.
      - @x,@y: center
      - @r: radius
      - @s: size
    ###
    Array::remove = (e) -> @[t..t] = [] if (t = @indexOf(e)) > -1

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
        canvas = p.createCanvas(756,512)
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

    ### Domain Functions

    These functions draw the stars, the planets, and carry out
    the logic of the game / sketch.
    - `setupStars`: initializes a random array of stars
    - `setupPlanets`: initializes an array of planets
    - `drawStars`: renders the stars as planes
    - `drawPlanets`: renders the planets
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


