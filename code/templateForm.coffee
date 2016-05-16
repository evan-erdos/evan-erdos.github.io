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

'use strict' # just like JavaScript


### const ###
url_regex = /^((ftp|https?):\/\/)?([\d\w\.-]+)\.([\w\.]{2,6})([\/\w \.-]*)*\/?$/


### DOM ###
#site = "http://bescott.org" # domain name
site = "http://localhost:4000" # domain name
#baseurl = "/inkwell" # subdomain

### Helper Functions ###
String::startsWith ?= (s) -> @slice(0,s.length)==s
String::endsWith   ?= (s) -> s=='' || @slice(-s.length)==s


### `TemplateForm`
#
# main class
###
class TemplateForm
    constructor: ->
        form = document.getElementById "form"
        nameLabel = document.createElement "label"
        nameLabel.appendChild(document.createTextNode("Room Name: "))
        @name = document.createElement "input"
        @name.type = "text"
        @name.onchange = window.submit
        nameLabel.for = @name
        form.appendChild(nameLabel)
        form.appendChild(@name)
        form.appendChild(document.createElement "br")
        selectLabel = document.createElement "label"
        selectLabel.appendChild(document.createTextNode("Event Type: "))
        @select = document.createElement "select"
        opts = ["SnapAudio", "PhotoDive","Map","DayInTheLife"]
        @createOption(opt,@select) for opt in opts
        selectLabel.for = @select
        form.appendChild(selectLabel)
        form.appendChild(@select)
        form.appendChild(document.createElement "br")
        descLabel = document.createElement "label"
        descLabel.appendChild(document.createTextNode("Room Description: "))
        @desc = document.createElement "textarea"
        @desc.rows = 24
        @desc.cols = 64
        descLabel.for = @desc
        form.appendChild(descLabel)
        form.appendChild(document.createElement "br")
        form.appendChild(@desc)
        form.appendChild(document.createElement "br")
        @result = document.createElement "pre"
        @result.style.color = '#fff'
        form.appendChild(@result)

    createOption: (s,select) ->
        option = document.createElement "option"
        option.value = s
        option.appendChild(document.createTextNode(s))
        select.appendChild(option)

    process: () =>
        yml =
            """
            %YAML 1.2
            --- !room
            name: #{@name.value}
            type: #{@select.value}
            rooms:
              south: whatever
              east: some room east of here
              225: etc
            description: |
              #{@desc.value}
            ...
            """
        @result.innerHTML = yml
        false



templateForm = new TemplateForm()
window.submit = () => templateForm.process()





















