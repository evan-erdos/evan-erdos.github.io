---
---

### Ben Scott # 2015-10-22 # Three ###

'use strict' # just like JavaScript

container = null

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
        @scene = new THREE.Scene()
        @camera = new THREE.PerspectiveCamera(
            75, 768/512, 1, 1000)
        @renderer = new THREE.WebGLRenderer(
            { antialias: true, alpha: true } )
        @renderer.setSize(768,512)
        @renderer.setClearColor(0xFFFFFF,0)

        #@controls = new THREE.OrbitControls(
        #    @camera,@renderer.domElement)

        [@planet,@sun] = [null,null]

    init: ->
        #jsonLoader.load("/rsc/3D/rocket.js", addModelToScene)
        ###
        loader.load(
            '/rsc/rook-top.png'
            (texture) =>
                material = new THREE.MeshLambertMaterial(
                    { map: texture }))
        ###
        #texture = THREE.TextureLoader('/rsc/rook-top.png')
        sun_geo = new THREE.SphereGeometry(60,64,64)
        sun_mat = new THREE.MeshBasicMaterial(
            { map: THREE.ImageUtils.loadTexture(
                "/rsc/sketch/sun.png") } )
        @sun = new THREE.Mesh(sun_geo,sun_mat)
        @scene.add(@sun)
        light = new THREE.PointLight(0xFFFFFF,2,256)
        @scene.add(light)
        planet_geo = new THREE.SphereGeometry(16,16,16)
        planet_geo.applyMatrix(
            new THREE.Matrix4().makeTranslation(0,0,-150))
        planet_mat = new THREE.MeshLambertMaterial(
            { map: THREE.ImageUtils.loadTexture(
                "/rsc/sketch/planet.png") })
        @planet = new THREE.Mesh(planet_geo,planet_mat)
        @sun.add(@planet)
        #@planet.position.set(128,0,0)
        @scene.add(@planet)
        @camera.position.z = 256
        container = document.getElementById("CoffeeSketch")
        container.appendChild(@renderer.domElement)
        #floor_albedo = new THREE.
        #ImageUtils.loadTexture('/rsc/rook-top.png')

    update: ->
        #controls.update()

    ### `Main.render`

    This is established as a callback via
    `requestAnimationFrame`, which does a bunch of stuff,
    e.g., calling render at the proper framerate, AFAIK.
    ###
    render: =>
        @update()
        requestAnimationFrame(@render)
        @renderer.clear()
        @sun.rotation.y += 0.005
        @planet.rotation.y += 0.02
        @renderer.render(@scene,@camera)

    ###
    addModelToScene: (geometry, materials) ->
        material = new THREE.MeshFaceMaterial(materials);
        mesh = new THREE.Mesh(geometry, material);
        mesh.scale.set(10,10,10);
        scene.add(mesh);
    ###

main = new Main()
main.init()
main.render()



