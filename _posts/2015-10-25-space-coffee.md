---
layout: code
title: Space
extension: .coffee
tag: [Programming, GameDev]
permalink: /code/space.coffee/
script: space
---

> Hey! This guy is trying to pass off the same project
> he did two projects ago as some sort of new thing!

No I'm not. Try clicking and dragging. Ohh, wow, look at it go.

## What's new? ##

A little of this, a little of that.
For starters, your browser is running [Three.js][] instead of [P5.js][], and [Three.js][] is ridiculously fast.
The planets are now affected by the sun's light (and its color) and have normal and specular mapping.
The stars in the background are not an image, but are `2^14` individual particles, distributed randomly, thousands of "lightyears" away.

[Three.js]: <http://threejs.org>
[P5.js]: <http://p5js.org>

~~~coffee
### Ben Scott # 2015-10-25 # Space ###

'use strict' # just like JavaScript

### Constants & Aliases ###
{abs,floor,random,sqrt} = Math # wow destructuring ooh
[pi,rate] = [Math.PI,60]
[rand,T] = [random,THREE] # i am not typing all this
next = (n) =>
    floor(random()*n)

### DOM ###
dir = "/js/assets/" # directory
divID = "CoffeeCode" # id of parent
container = null # parent in the HTML document

### WebGL ###
renderers = [] # list of objects to render
textureLoader = new T.TextureLoader()
~~~


### `Planet` ###

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

~~~coffee
class Planet
    constructor: (params = {}) -> # destructure
        @radius = params.radius ? (1+rand())*32
        @dist = params.dist ? (rand()-0.5)*2**12
        @dist -= 512 if (@dist<0)
        @dist += 512 if (0<@dist)
        @orbit = params.orbit ? (rand()-0.5)
        @period = params.period ? (rand()-0.5)*10
        @declin = params.declin ? (rand()-0.5)*0.5
        @color = params.color ? Planet.color
        @file = params.file ? Planet.file
        @albedo = params.albedo ? Planet.albedo
        @spec = params.spec ? Planet.spec
        @normal = params.normal ? Planet.normal

        @mat = new T.MeshPhongMaterial {
            color: @color
            specular: 0xAAAAAA
            shininess: 10
            map: @albedo
            specularMap: @spec
            normalMap: @normal
            normalScale: new T.Vector2(0.8,0.8) }

        @geo = new T.SphereGeometry(@radius,16,16)
        @mesh = new T.Mesh(@geo,@mat)
        #@mesh.castShadow = true
        #@mesh.recieveShadow = true
        @obj = new T.Object3D()
        @obj.add @mesh
        main.scene.add @obj
        renderers.push @

    @init: ->
        Planet.color = 0xDDDDDD
        Planet.file = "planet"
        Planet.albedo = textureLoader.load(
            "#{dir}#{Planet.file}_albedo.png")
        Planet.spec = textureLoader.load(
            "#{dir}#{Planet.file}_spec.png")
        Planet.normal = textureLoader.load(
            "#{dir}#{Planet.file}_normal.jpg")

    render: =>
        @mesh.rotation.y += @period/rate
        @mesh.position.z = @dist
        @obj.rotation.x = @declin
        @obj.rotation.y += @orbit/rate
~~~


### `GasGiant` ###

This class represents large planetary bodies.

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

~~~coffee
class GasGiant extends Planet
    constructor: (params = {}) -> # destructure
        @radius = params.radius ? (2+rand())*64
        @dist = params.dist ? (rand()-0.5)*2**12
        @dist -= 512 if (@dist<0)
        @dist += 512 if (0<@dist)
        @orbit = params.orbit ? (rand()-0.5)
        @period = params.period ? (rand()-0.5)*10
        @declin = params.declin ? (rand()-0.5)*0.5
        @color = params.color ? GasGiant.color
        @file = params.file ? GasGiant.file
        @albedo = params.albedo ? GasGiant.albedo
        @spec = params.spec ? GasGiant.spec
        @normal = params.normal ? GasGiant.normal

        @mat = new T.MeshPhongMaterial {
            color: @color
            specular: 0x222222
            shininess: 20
            map: @albedo
            specularMap: @spec
            normalMap: @normal
            normalScale: new T.Vector2(0.6,0.6) }

        @geo = new T.SphereGeometry(@radius,32,32)
        @mesh = new T.Mesh(@geo,@mat)
        @mesh.castShadow = true
        @mesh.recieveShadow = true
        @obj = new T.Object3D()
        @obj.add @mesh
        main.scene.add @obj
        renderers.push @

    @init: ->
        GasGiant.color = 0xDDDDDD
        GasGiant.file = "gas_giant"
        GasGiant.albedo = textureLoader.load(
            "#{dir}#{GasGiant.file}_albedo.png")
        GasGiant.spec = textureLoader.load(
            "#{dir}#{GasGiant.file}_spec.png")
        GasGiant.normal = textureLoader.load(
            "#{dir}#{GasGiant.file}_normal.jpg")
~~~


### `Star` ###

This class represents stars. It creates a light object along with it's mesh.

- `@radius` **int** : radius (km)
- `@period` **real** : day period (ms)
- `@glow` **real**: sunlight intensity
- `@color` **hex** : hex code for tint
- `@file` **string** : file name
- `@obj` **Object3D** : root object
- `@albedo` **Texture** : surface texture
- `@mat` **Material** : lambert material
- `@geo` **Geometry** : sphere for sun
- `@mesh` **Mesh** : sun's mesh
- `@light` **PointLight** : sun's light object

~~~coffee
class Star extends Planet
    constructor: (params = {}) -> # destructure
        @radius = params.radius ? (rand()+1)*256
        @period = params.period ? (rand()-0.5)*0.1
        @glow = params.glow ? Star.glow
        @color = params.color ?
            if @radius<300 then 0xFFEEAA else 0xBBBBFF
        @file = params.file ?
            if @radius<300 then "sun" else "blue"
        @albedo = params.albedo ?
            textureLoader.load(
                "#{dir}#{@file}_albedo.png")

        @geo = new T.SphereGeometry(@radius,64,64)
        @mat = new T.MeshBasicMaterial { map: @albedo }
        @mesh = new T.Mesh(@geo,@mat)
        @light = new T.PointLight(@color,@glow,0)
        #@light.castShadow = true
        #@light.shadowDarkness = 0.75
        @obj = new T.Object3D()
        @obj.add @mesh
        @obj.add @light
        main.scene.add @obj
        renderers.push @

    @init: ->
        Star.file = "sun"
        Star.glow = 2
        Star.nova = 300

    render: ->
        @obj.rotation.y += @period/rate
~~~


### `Main` ###

This is the program entry point for the whole affair
- `@scene`: An object representing everything in the
    environment, including `camera`s, 3D models, etc.
- `@camera`: The main rendering viewpoint, typically uses
    perspective rather than orthogonal rendering.
- `@renderer`: ... I'll... get back to you about exactly
    what it is that this one does!

~~~coffee
class Main
    constructor: ->
        @scene = new T.Scene()
        @scene.fog = new T.Fog(0x00,2**12,2**16)
        @camera = new T.PerspectiveCamera(
            75,768/512,1,65536)
        @renderer = new T.WebGLRenderer {
            antialias: true, alpha: false }
        @renderer.setSize(768,512)
        @renderer.setClearColor(0x0,0)
        #@renderer.shadowMap.enabled = true
        #@renderer.shadowMap.type = T.PCFSoftShadowMap

    init: ->
        @initDOM()
        @initControls()
        @initPlanets()
        @initStarField()
        @camera.position.z = 2048
        @render()

    initDOM: ->
        container = document.getElementById(divID)
        container.appendChild(@renderer.domElement)

    initControls: ->
        @controls = new T.OrbitControls(
            @camera,@renderer.domElement)
        @controls.userZoom = false

    initPlanets: ->
        Planet.init()
        GasGiant.init()
        Star.init()
        @sun = new Star()
        new Planet() for i in [0..next(8)]
        new GasGiant() for i in [0..next(3)]

    initStarField: ->
        geometry = new T.Geometry()
        for i in [0..2**14]
            v = new T.Vector3(
                T.Math.randFloatSpread 2**16
                T.Math.randFloatSpread 2**14
                T.Math.randFloatSpread 2**16)
            if (abs(v.x)>2**12 ||
                abs(v.y)>2**12 ||
                abs(v.z)>2**12)
                    geometry.vertices.push v
        stars = new T.Points(
            geometry
            new T.PointsMaterial { color: 0x999999 })
        @scene.add stars

    update: ->
        @controls.update()
~~~


### `Main.render` ###

This needs to be a bound function, and is the callback used by `requestAnimationFrame`, which does a bunch of stuff, e.g., calling render at the proper frame rate.

~~~coffee
    render: =>
        requestAnimationFrame(@render)
        @update()
        rend.render() for rend in renderers
        @renderer.render(@scene,@camera)
~~~


Finally, we instantiate a new main, initialize, and a call to init starts the loop.

~~~coffee
main = new Main()
main.init()
~~~
