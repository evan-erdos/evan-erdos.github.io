---
---

### Ben Scott # 2015-10-24 # Three ###

'use strict' # just like JavaScript

### Constants & Aliases ###
pi = Math.PI
framerate = 60
T = THREE
rand = Math.random
next = (n) => Math.floor(Math.random()*n)

#str_color = (r,g,b) =>
#    '\##{(0x1000000+b+0x100*g+0x10000*r).toString(16).substr(1)}'

### DOM ###
dir = "/rsc/sketch/" # directory
container = null # parent in the HTML document

### WebGL ###
renderers = [] # list of objects to render

### Three.js ###
tex_loader = new T.TextureLoader()

### `Planet`

This class represents planetary bodies.
- `@radius` **int** : radius (km)
- `@dist` **int** : distance from sun (km)
- `@orbit` **real** : orbit time (ms)
- `@period` **real** : day period (ms)
- `@declin` **real** : Z-Axis declination (rad)
- `@color` **hex** : hex code for tint
- `@file` **string** : file name for resources
- `@obj` **Object3D** : root object
- `@albedo` **Texture** : surface texture
- `@normal` **Texture** : normal map
- `@spec` **Texture** : specular map
- `@mat` **Material** : lambert material
- `@geo` **Geometry** : sphere for planets
- `@mesh` **Mesh** : planet's mesh
###
class Planet
    constructor: (params = {}) ->
        @radius = params.radius ?
            (1+rand())*32
        @dist = params.distance ?
            ((rand()-0.5)*32)*256
        @orbit = params.orbit ?
            (rand()-0.5)
        @period = params.period ?
            (rand()-0.5)*10
        @declin = params.declin ?
            (rand()-0.5)*0.5
        @file = params.file ?
            "planet"
        @color = params.color ?
            0xAAAAAA
        @albedo = params.albedo ?
            Planet.albedo
        @spec = params.spec ?
            Planet.spec
        @normal = params.normal ?
            Planet.normal

        @mat = new T.MeshPhongMaterial {
            color: @color
            specular: 0x222222
            shininess: 10
            map: @albedo
            specularMap: @spec
            normalMap: @normal
            normalScale: new T.Vector2(0.8,0.8) }

        @geo = new T.SphereGeometry(@radius,16,16)
        @mesh = new T.Mesh(@geo,@mat)
        @obj = new T.Object3D()
        @obj.add @mesh
        main.scene.add @obj

        renderers.push @

    @init: ->
        file = "planet"
        Planet.albedo = tex_loader.load(
            "#{dir}#{file}_albedo.png")
        Planet.spec = tex_loader.load(
            "#{dir}#{file}_spec.png")
        Planet.normal = tex_loader.load(
            "#{dir}#{file}_normal.jpg")

    render: =>
        @mesh.rotation.y += @period/framerate
        @mesh.position.z = @dist
        @obj.rotation.x = @declin
        @obj.rotation.y += @orbit/framerate

    randomize: ->
        @radius = (rand()+1)*32
        filename = if @radius<48 then "planet" else "gas"
        @tex = tex_loader.load "#{dir}#{filename}.png"
        @dist = ((rand()-0.5)*16)*256
        if (@d<0) then @d -= 512 else @d += 512
        @orbit = (rand()-0.5)*10
        @period = (rand()-0.5)
        @declin = (rand()-0.5)*0.5

### `Star`

This class represents stars. It creates a light object
along with it's mesh.
- `@r` **int** : radius (km)
- `@o` **real** : day period (rad/ms)
- `@i` **real** : sun intensity
- `@c` **hex** : sun color
- `@tex` **Texture** : surface texture
- `@mat` **Material** : basic material (looks like glow)
- `@geo` **Geometry** : sphere for sun's surface
- `@mesh` **Mesh** : sun's mesh
- `@light` **PointLight** : sun's emissions
###
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
        filename = if @r<300 then "sun" else "blue"
        @tex = tex_loader.load "#{dir}#{filename}_albedo.png"
        @c = if @r<300 then 0xFFEEAA else 0xBBBBFF

### `Main`

This is the program entrypoint for my three.js example.
- `@scene`: An object representing everything in the
    environment, including `camera`s, 3D models, etc.
- `@camera`: The main rendering viewpoint, typically uses
    perspective rather than orthogonal rendering.
- `@renderer`: ... I'll... get back to you about exactly
    what it is that this one does!
###
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
        @initControls()
        @initPlanets()
        @camera.position.z = 1024
        @render()

    initDOM: ->
        container = document.getElementById("CoffeeSketch")
        container.appendChild(@renderer.domElement)

    initControls: ->
        @controls = new T.OrbitControls(
            @camera,@renderer.domElement)
        @controls.userZoom = true
        @controls.minDistance = 512
        @controls.maxDistance = 2048

    initPlanets: ->
        Planet.init()
        @sun = new Star()
        new Planet() for i in [0..Math.floor(rand()*8)]

        @followPlanet = new Planet()

    update: ->
        @controls.update()

    ### `Main.render`

    This needs to be a bound function, and is the callback
    used by `requestAnimationFrame`, which does a bunch of
    stuff, e.g., calling render at the proper framerate.
    ###
    render: =>
        requestAnimationFrame(@render)
        @update()
        rend.render() for rend in renderers
        @renderer.render(@scene,@camera)

    addModelToScene: (geometry, materials) ->
        material = new T.MeshFaceMaterial(materials);
        mesh = new T.Mesh(geometry, material);
        mesh.scale.set(10,10,10);
        @scene.add(mesh);

main = new Main()
main.init()
