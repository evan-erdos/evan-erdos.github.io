---
---

### Ben Scott # 2015-10-26 # Viewer ###

'use strict'

### Constants & Aliases ###
{abs,floor,random,sqrt} = Math
T = THREE

### DOM ###
dir = "/js/assets/" # directory
divID = "CoffeeCode" # id of parent
container = null # parent in document

### WebGL ###
loader = new T.JSONLoader()
objectLoader = new T.ObjectLoader()
objLoader = new T.OBJLoader()
textureLoader = new T.TextureLoader()


### `Viewer`
#
# This is the program entrypoint, and it initializes all of the
# [Three.js][] objects.
# - `@scene`: An object representing everything in the
#     environment, including `camera`s, 3D models, etc.
# - `@camera`: The main rendering viewpoint, typically uses
#     perspective rather than orthogonal rendering.
# - `@renderer`: ... I'll... get back to you about exactly
#     what it is that this one does!
###
class Viewer
    constructor: (@filename,@distance = 1) ->
        @scene = new T.Scene()
        @camera = new T.PerspectiveCamera(
            75,768/512,1,65536)
        @renderer = new T.WebGLRenderer {
            antialias: true, alpha: true }
        @renderer.setSize(768,512)
        @renderer.setClearColor(0x0,0)
        @ambient = new T.AmbientLight(0x404040)
        @scene.add @ambient
        @light = new T.DirectionalLight(0xEFEFED,1)
        @light.position.set(512,512,512)
        @model = {
            mesh: null
            material: null
            albedo: null
            normal: null
            specular: null
        }

        @model.material = @createMaterial(
            @model.albedo
            @model.normal
            @model.specular)

        @scene.add @light
        @import3D(@filename)
        @init()


    init: ->
        @initDOM()
        @initControls()
        @camera.position.z = @distance
        @render()


    initDOM: ->
        container = document.getElementById(divID)
        container.appendChild(@renderer.domElement)


    initControls: ->
        @controls = new T.OrbitControls(
            @camera,@renderer.domElement)
        @controls.userZoom = false


    ### `Viewer.render`
    #
    # This needs to be a bound function, and is the callback
    # used by `requestAnimationFrame`, which does a bunch of
    # stuff, e.g., calling render at the proper framerate.
    ###
    render: =>
        requestAnimationFrame(@render)
        @controls.update()
        @renderer.render(@scene,@camera)

    ### `Viewer.import3D`
    #
    # This needs to be a bound function, and is the callback
    # used by the `JSONLoader` to initialize geometry from
    # the provided filename.
    ###
    import3D: (filename) =>
        textureLoader.load(
            "#{dir}#{filename}-albedo.png"
            (texture) =>
                @model.albedo = texture
                texture.needsUpdate = true)

        textureLoader.load(
            "#{dir}#{filename}-normal.jpg"
            (texture) =>
                @model.normal = texture
                @loadModel(filename)
                texture.needsUpdate = true)

        #textureLoader.load(
        #    "#{dir}#{filename}-specular.png"
        #    (texture) =>
        #        @model.specular = texture
        #        texture.needsUpdate = true)

    loadModel: (filename) =>
        objLoader.load(
            "#{dir}#{filename}.obj"
            (object) =>
                object.traverse (child) =>
                    return unless (child instanceof T.Mesh)
                    #@model.mesh = child
                    #@model.mesh.material = new T.MeshPhongMaterial {
                    #    color: 0xFFFFFF
                    #    specular: 0xAAAAAA
                    #    shininess: 10
                    #    map: @model.albedo }
                    mat = new T.MeshPhongMaterial {
                        color: 0xFFFFFF
                        specular: 0xAAAAAA
                        shininess: 10
                        map: @model.albedo
                        specularMap: @model.specular
                        normalMap: @model.normal
                        normalScale: new T.Vector2(0.8,0.8) }
                    mesh = new T.Mesh(child.geometry, mat)
                    console.log mesh
                    #@model.mesh.material.map = @model.albedo
                    #@model.mesh.material.normalMap = @model.normal
                    #child.material = @createMaterial(
                    #    @model.albedo
                    #    @model.normal
                    #    @model.specular)
                    #@model.
                    mesh.scale.set(100,100,100)
                    @renderer.render(@scene,@camera)
                    @scene.add mesh)



    createMaterial: (albedo, normal, specular) =>
        new T.MeshPhongMaterial {
            color: 0xFFFFFF
            specular: 0xAAAAAA
            shininess: 10
            map: albedo
            specularMap: specular
            normalMap: normal
            normalScale: new T.Vector2(0.8,0.8) }



### `@createViewer`
#
# This is a global function, callable from other scripts, and
# will be used with another script on the page to load an
# arbitrary 3D model into a basic scene.
###
@createViewer = (filename, distance=1) =>
    new Viewer(filename,distance)







