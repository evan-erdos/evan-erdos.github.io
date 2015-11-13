---
---

### Ben Scott # 2015-10-25 # Brian_Eno ###

'use strict' # just like JavaScript

### Constants & Aliases ###
{abs,floor,random,sqrt} = Math
[pi,rate] = [Math.PI,60]
[rand,T] = [random,THREE]
next = (n) => floor(random()*n)

### DOM ###
dir = "/js/assets" # directory
divID = "CoffeeCode" # id of parent
container = null # parent in the HTML document

### WebGL ###
renderers = [] # list of objects to render
loader = new T.JSONLoader()
textureLoader = new T.TextureLoader()

### Brian Eno ###
crystals = []

### `Crystal`

This class represents a crystalline object which makes noise
when clicked on.
- `@radius` **int** : radius (km)
- `@dist` **int** : distance (km)
- `@period` **real** : day period (ms)
- `@color` **hex** : hex code for tint
- `@file` **string** : file name for resources
- `@obj` **Object3D** : root object
- `@albedo` **Texture** : surface texture
- `@normal` **Texture** : normal map
- `@spec` **Texture** : specular map
- `@mat` **Material** : lambert material
- `@geo` **Geometry** : sphere for crystals
- `@mesh` **Mesh** : planet's mesh
###
class Crystal
    constructor: (params = {}) -> # destructure
        @radius = params.radius ? (1+rand())*32
        @dist = params.dist ? rand()*2**12+512
        @period = params.period ? (rand()-0.5)*10
        @color = params.color ? Crystal.color
        @file = params.file ? Crystal.file
        @albedo = params.albedo ? Crystal.albedo
        @spec = params.spec ? Crystal.spec
        @normal = params.normal ? Crystal.normal

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
        @obj = new T.Object3D()
        @obj.add @mesh
        main.scene.add @obj
        renderers.push @

    @init: ->
        Crystal.color = 0xDDDDDD
        Crystal.file = "planet"
        Crystal.albedo = textureLoader.load(
            "#{dir}/#{Crystal.file}_albedo.png")
        Crystal.spec = textureLoader.load(
            "#{dir}/#{Crystal.file}_spec.png")
        Crystal.normal = textureLoader.load(
            "#{dir}/#{Crystal.file}_normal.jpg")

    render: =>
        renderer.domElement.addEventListener('mousedown', ()->
            v = new T.Vector3(
                renderer.devicePixelRatio*(event.pageX-@offsetLeft)/@width*2-1
                -renderer.devicePixelRatio*(event.pageY-@offsetTop*2+1),0))


### `Main`

This is the program entrypoint for the whole affair
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
        @scene.fog = new T.Fog(0x00,2**12,2**16)
        @camera = new T.PerspectiveCamera(
            75,768/512,1,65536)
        @renderer = new T.WebGLRenderer {
            antialias: true, alpha: false }
        @renderer.setSize(768,512)
        @renderer.setClearColor(0x0,0)
        loader.load(
            "#{dir}/#{file_rocket}.js"
            (geo) =>
                mat = new T.MeshLambertMaterial {
                    color: 0xAEAEAE }

                mesh = new T.Mesh(geo, mat)
                mesh.position.z -= 1024
                mesh.rotation.y = pi/2
                mesh.scale.set(50,50,50)
                @scene.add mesh)

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
        for i in [0..next(12)]
            crystals.push(new Crystal())

        for planet0 in crystals
            for planet1 in crystals
                break if (planet0 is planet1)
                if abs(planet0.dist-planet1.dist)<256
                    planet1.dist += 2**9

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

    import3D: (filename) ->
        loader.load(
            "#{dir}/#{filename}.js"
            (geo) =>
                mat = new T.MeshPhongMaterial {
                    color: 0xAEAEAE
                    specular: 0xAAAAAA }
                mesh = new T.Mesh(geo, mat)
                mesh.position.z -= 1024
                mesh.rotation.y = pi/2
                mesh.scale.set(50,50,50)
                @scene.add mesh)

main = new Main()
main.init()
