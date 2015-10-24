---
layout: three
title: Three.coffee
tag: [Programming, GameDev]
permalink: /three/changes.coffee/
script: changes
---

This has very little to do with the project assigned, but wow, look at what happens when you click and drag! Three.js is pretty neat. Real lights? UV Maps without giant holes in them? Sign me up.

Here's some variables and loaders for assets and whatnot.

```coffee
### Ben Scott # 2015-10-24 # Three ###

'use strict' # just like JavaScript

### Constants & Aliases ###
pi = Math.PI
framerate = 60
rand = Math.random
T = THREE

### DOM ###
dir = "/rsc/sketch/" # directory
container = null # parent in the HTML document

### WebGL ###
renderers = [] # list of objects to render

### Three.js ###
textureLoader = new T.TextureLoader()
```


### `Planet` ###

This class represents planetary bodies.

- `@r` **int** : radius (km)
- `@d` **int** : distance from sun (km)
- `@t` **real** : orbit time (ms)
- `@o` **real** : day period (ms)
- `@z` **real** : Z-Axis offset (rad)
- `@obj` **T.Object3D** : pivot object
- `@tex` **T.Texture** : surface texture
- `@mat` **T.Material** : lambert material
- `@geo` **T.Geometry** : sphere for planets
- `@mesh` **T.Mesh** : planet's mesh

```coffee
class Planet
    constructor: (@r=-1,@d=256,@t=0.1,@o=0.05,@z=0.0) ->
        @randomize() if @r<0
        @obj = new T.Object3D()
        @mat = new T.MeshLambertMaterial { map: @tex }
        @geo = new T.SphereGeometry(@r,16,16)
        @mesh = new T.Mesh(@geo,@mat)
        main.scene.add @obj
        main.scene.add @mesh
        @obj.add @mesh

        renderers.push @

    render: =>
        @mesh.rotation.y += @o/framerate
        @mesh.position.z = @d
        @obj.rotation.x = @z
        @obj.rotation.y += @t/framerate

    randomize: ->
        @r = (rand()+1)*32
        filename = if @r<48 then "planet" else "gas_giant"
        @tex = textureLoader.load "#{dir}#{filename}.png"
        @d = ((rand()-0.5)*16)*256
        if (@d<0) then @d -= 512 else @d += 512
        @o = (rand()-0.5)*10
        @t = (rand()-0.5)
        @z = (rand()-0.5)*0.5
```


### `Star` ###

This class represents stars. It creates a light object along with it's mesh.

- `@r` **int** : radius (km)
- `@o` **real** : day period (rad/ms)
- `@i` **real** : sun intensity
- `@c` **hex** : sun color
- `@tex` **T.Texture** : surface texture
- `@mat` **T.Material** : basic material (looks like glow)
- `@geo` **T.Geometry** : sphere for sun's surface
- `@mesh` **T.Mesh** : sun's mesh
- `@light` **T.PointLight** : sun's emissions

```coffee
class Star extends Planet
    constructor: (@r=-1, @o=0.05, @i=1, @c=0xFF) ->
        @randomize() if @r<0
        [@d,@t,@z] = [0,0.0,0.0]
        @geo = new T.SphereGeometry(@r,64,64)
        @mat = new T.MeshBasicMaterial { map: @tex }
        @mesh = new T.Mesh(@geo,@mat)
        @light = new T.PointLight(@c,@i,0)
        @light.shadowDarkness = 0.75
        main.scene.add @light
        main.scene.add @mesh
        renderers.push @

    render: ->
        @mesh.rotation.y += @o/framerate

    randomize: ->
        @r = 256+rand()*128
        @o = (rand()-0.5)*0.1
        @o += 0.1 if Math.abs(@o)<0.1
        filename = if @r<300 then "sun" else "blue_sun"
        @tex = textureLoader.load "#{dir}#{filename}.png"
        @c = if @r<300 then 0xFFEEAA else 0xBBBBFF
```


### `Main` ###

This is the program entrypoint for my three.js example.

- `@scene`: An object representing everything in the environment, including `camera`s, 3D models, etc.
- `@camera`: The main rendering viewpoint, typically uses perspective rather than orthogonal rendering.
- `@renderer`: ... I'll... get back to you about exactly what it is that this one does!

```coffee
class Main
    constructor: ->
        @scene = new T.Scene()
        @camera = new T.PerspectiveCamera(
            75,768/512,1,65536)
        @renderer = new T.WebGLRenderer {
            antialias: true, alpha: true }
        @renderer.setSize(768,512)
        @renderer.setClearColor(0xFFFFFF,0)

    init: ->
        @initDOM()
        @initPlanets()
        @camera.position.z = 1024
        @controls = new T.OrbitControls(
            @camera,@renderer.domElement)
        @controls.userZoom = false
        @render()

    initDOM: ->
        container = document.getElementById("CoffeeSketch")
        container.appendChild(@renderer.domElement)

    initPlanets: ->
        @sun = new Star()
        new Planet() for i in [0..4]

    update: ->
        @controls.update()
```


### `Main.render` ###

This needs to be a bound function, and is the callback used by `requestAnimationFrame`, which does a bunch of stuff, e.g., calling render at the proper framerate.

```coffee
    render: =>
        requestAnimationFrame(@render)
        @update()
        rend.render() for rend in renderers
        @renderer.render(@scene,@camera)
```


Finally, we instantiate a new main, initialize, and a call to init starts the loop.

```coffee
main = new Main()
main.init()
```
