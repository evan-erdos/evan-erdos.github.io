---
---


### `TemplateForm`
#
# Simple web form to generate `*.yml` metadata.
#
# Ben Scott
# <bescott@andrew.cmu.edu>
# 2016-06-16
###
class TemplateForm
    constructor: (@room) ->
        form = document.getElementById 'form'

        @name = @createInput('text','name')
        @name.value = @room.name
        @addFormField(form,@name,'Room Name')

        @image = @createInput('file','image')
        @image.defaultValue = @room.image
        @image.accept = 'image/*'
        @addFormField(form,@image,'Panorama')

        @select = @createSelect(@room.options)
        @addFormField(form,@select,'Room Type')

        form.appendChild(document.createElement 'hr')
        @desc = @createTextArea(8,64)
        @desc.innerHTML = @room.description
        @addFormField(form,@desc,'Description')

        form.appendChild(document.createElement 'hr')
        @sounds = []
        for sound,i in @room.sounds
            div = document.createElement 'div'
            file = @createInput('file',"sound-#{i}")
            file.defaultValue = sound.f
            x = @createInput('number',"x-#{i}")
            x.value = sound.v.x
            y = @createInput('number',"y-#{i}")
            y.value = sound.v.y
            xy = [x,y]
            div.appendChild @createLabel(file,"Sound #{i+1}")
            div.appendChild file
            div.appendChild xy[0]
            div.appendChild xy[1]
            form.appendChild div
            @sounds.push {file,xy}

        form.appendChild(document.createElement 'hr')
        @rooms = []
        for r,i in @room.rooms
            div = document.createElement 'div'
            room = @createInput('text',"room-#{i}")
            room.value = r.name
            dir = @createInput('text',"room-#{i}-dir")
            dir.value = r.dir
            div.appendChild @createLabel(room,"Room #{i+1}")
            div.appendChild room
            div.appendChild dir
            form.appendChild div
            @rooms.push {dir,room}

        form.appendChild(document.createElement 'hr')
        @result = document.createElement 'pre'
        @result.style.color = '#fff'
        form.appendChild(@result)


    addFormField: (form,field,name) ->
        form.appendChild @createLabel(field,name)
        form.appendChild(document.createElement 'br')
        form.appendChild field
        form.appendChild(document.createElement 'br')

    createTextArea: (rows,cols) ->
        field = document.createElement 'textarea'
        field.rows = rows
        field.cols = cols
        field

    createLabel: (field,name) ->
        label = document.createElement 'label'
        label.appendChild(document.createTextNode(name))
        label.for = field
        label

    createInput: (type,name) ->
        field = document.createElement 'input'
        field.type = type
        field.name = name
        field.onchange = window.submit
        field

    createOption: (select,value) ->
        option = document.createElement 'option'
        option.value = value
        option.appendChild(document.createTextNode(value))
        option

    createSelect: (options) ->
        select = document.createElement 'select'
        for option in options
            select.appendChild @createOption(select,option)
        select

    process: () =>
        @room.name = @name.value
        @room.type = @select.value
        @room.desc = ("\n  #{s}" for s in @desc.value.split /\n/g).join('')
        if @image.value!=''
            @room.image = @image.value.replace(/.*[\/\\]/, '')
        sounds = ("\n  <#{s.v.x},#{s.v.y}>: #{s.f}" for s in @room.sounds).join('')
        rooms = ("\n  #{s.dir.value}: #{s.room.value}" for s in @rooms).join('')
        yml =
            """
            %YAML 1.2
            --- !room
            name: #{@room.name}
            type: #{@room.type}
            image: #{@room.image}
            rooms: #{rooms}
            sounds: #{sounds}
            description: | #{@room.desc}
            ...
            """
        @result.innerHTML = yml
        false


room =
    name: 'My Room'
    image: 'example_panorama.jpg'
    type: 'Snap Audio'
    options: [
        'Snap Audio'
        'Photo Dive'
        'Map'
        'A Day In the Life' ]
    description:
        """
        This is an entirely unremarkable room.
        There are many like it, but this is the one you're in.
        You've seen a lot of rooms, and this is one of them.
        There are some adjacent rooms, and some sounds here.
        """
    sounds: [
        v: {x: 134, y: 1353}
        f: 'whiteboard.wav'
    ,
        v: { x: 237, y: 53 }
        f: 'other-sound.wav'
    ,
        v: { x: 5, y: 742 }
        f: 'third-sound.wav' ]
    rooms: [
        dir: 'north'
        name: 'A Room North of Here'
    ,
        dir: 'SE'
        name: 'Some Other Room'
    ,
        dir: '225'
        name: 'Third Room' ]


templateForm = new TemplateForm(room)
window.submit = () => templateForm.process()
templateForm.process()











