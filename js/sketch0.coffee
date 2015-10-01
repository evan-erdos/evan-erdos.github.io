---
---

# the Kosbie spin

r_slider = null
g_slider = null
b_slider = null
size_slider = null

n_point = 1024

myp = new p5 (p)->
  p.setup = ->
    size_slider = p.createSlider(1,8,4)
    r_slider = p.createSlider(0,255,100)
    g_slider = p.createSlider(0,255,0)
    b_slider = p.createSlider(0,255,255)
    p.createCanvas p.windowWidth, p.windowHeight
    p.frameRate 60

  p.draw = ->
    size = size_slider.value()
    [x,y] = [32*size,32*size]
    rand = 0;
    for i in [1...n_point]
        p.stroke "grey"
        p.fill(16,16,16)
        p.ellipse((p.width/n_point)*i,(p.height/2) + p.random(-rand,rand),12,12)
        rand+= random(-5,5)

    r = r_slider.value()
    g = g_slider.value()
    b = b_slider.value()
    if p.mouseIsPressed
        #p.fill(p.random 255,p.random 255,p.random 255,127)
        p.fill(r,g,b,127)
        p.stroke "grey"
        n = p.random size/2
        p.ellipse p.mouseX, p.mouseY, x*n, y*n


    #   [x,y] = [16,16]
    #else
    #   p.stroke "grey"
    #   p.fill 255
    #   [x,y] = [10,10]
