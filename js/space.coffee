---
---

### Ben Scott # 2015-10-25 # Space ###

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

file_rocket = "vulcain_v0.1.48"

### Space ###
planets = []

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
    constructor: (params = {}) -> # destructure
        @radius = params.radius ? (1+rand())*32
        @dist = params.dist ? rand()*2**12+512
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
            "#{dir}/#{Planet.file}_albedo.png")
        Planet.spec = textureLoader.load(
            "#{dir}/#{Planet.file}_spec.png")
        Planet.normal = textureLoader.load(
            "#{dir}/#{Planet.file}_normal.jpg")

    render: =>
        @mesh.rotation.y += @period/rate
        @mesh.position.z = @dist
        @obj.rotation.x = @declin
        @obj.rotation.y += @orbit/rate


### `GasGiant`

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
###
class GasGiant extends Planet
    constructor: (params = {}) -> # destructure
        @radius = params.radius ? (1+rand())*128
        @dist = params.dist ? rand()*2**12+1024
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
            "#{dir}/#{GasGiant.file}_albedo.png")
        GasGiant.spec = textureLoader.load(
            "#{dir}/#{GasGiant.file}_spec.png")
        GasGiant.normal = textureLoader.load(
            "#{dir}/#{GasGiant.file}_normal.jpg")

### `Star`

This class represents stars. It creates a light object
along with it's mesh.
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
###
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
                "#{dir}/#{@file}_albedo.png")

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
        ###
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
        ###
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
        for i in [0..next(12)]
            planets.push(new Planet())
        for i in [0..next(5)]
            planets.push(new GasGiant())

        for planet0 in planets
            for planet1 in planets
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
