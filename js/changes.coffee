---
---

### Ben Scott # 2015-10-22 # Three ###

'use strict' # just like JavaScript

### WebGL ###
#loader = new THREE.TextureLoader();
#jsonLoader = new THREE.JSONLoader()
[geometry, material, mesh] = [null,null,null]

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
    constructor: () ->
        @scene = new THREE.Scene()
        @camera = new THREE.PerspectiveCamera(
            75, 768/512, 1, 1000)
        @renderer = new THREE.WebGLRenderer(
            { antialias: true, alpha: true } )
        @renderer.setSize(768,512)
        @renderer.setClearColor(0xFFFFFF,0)

    init: ->
        #jsonLoader.load("/rsc/3D/rocket.js", addModelToScene)
        geometry = new THREE.BoxGeometry(10,10,10)
        ###
        loader.load(
            '/rsc/rook-top.png'
            (texture) =>
                material = new THREE.MeshLambertMaterial(
                    { map: texture }))
        ###
        #texture = THREE.TextureLoader('/rsc/rook-top.png')
        light = new THREE.PointLight(0xFFFFFF,3,100)
        light.position.set(20,20,20)
        @scene.add(light)
        material = new THREE.MeshLambertMaterial(
            { map: THREE.ImageUtils.loadTexture(
                "/rsc/rook-top.png") } );
        mesh = new THREE.Mesh(geometry, material)
        @scene.add(mesh)
        @camera.position.z = 15
        document.getElementById("CoffeeSketch").appendChild(
            @renderer.domElement)
        #floor_albedo = new THREE.
        #ImageUtils.loadTexture('/rsc/rook-top.png')

    ### `Main.render`

    This is established as a callback via
    `requestAnimationFrame`, which does a bunch of stuff,
    e.g., calling render at the proper framerate, AFAIK.
    ###
    render: =>
        requestAnimationFrame(@render)
        @renderer.clear()
        mesh.rotation.x += 0.01
        mesh.rotation.y += 0.02
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



