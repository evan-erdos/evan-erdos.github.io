---
---

# CoffeeScript Sketch
r_slider = null
g_slider = null
b_slider = null
size_slider = null
rand_slider = null

n_point = 1024

myp = new p5 (p)->
  p.setup = ->
    p.noStroke()
    size_slider = p.createSlider(1,8,4)
    rand_slider = p.createSlider(0,120,4)
    r_slider = p.createSlider(0,255,100)
    g_slider = p.createSlider(0,255,0)
    b_slider = p.createSlider(0,255,255)
    p.createCanvas p.windowWidth, p.windowHeight
    p.frameRate 60

  p.draw = ->
    p.text("Size:")
    size = size_slider.value()
    [x,y] = [32*size,32*size]
    rand_x = rand_slider.value()
    rand_y = rand_slider.value()
    #for i in [1...n_point]
    #    p.stroke "grey"
    #    p.fill(16,16,16)
    #    p.ellipse((p.width/n_point)*i,(p.height/2) + p.random(-rand,rand),12,12)
    #    rand+= random(-5,5)

    r = r_slider.value()
    g = g_slider.value()
    b = b_slider.value()
    if p.mouseIsPressed
        #p.fill(p.random 255,p.random 255,p.random 255,127)
        p.fill(r,g,b,127)
        #p.stroke "grey"
        n = p.random size/2
        p.ellipse(p.mouseX+p.random(-rand_x, rand_x), p.mouseY+p.random(-rand_y, rand_y), x*n, y*n)





