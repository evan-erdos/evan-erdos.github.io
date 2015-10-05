---
---

# Ben Scott # 2015-10-02 # CoffeeScript Sketch #

myp = new p5 (p)->
    alt = false
    [r_sl,g_sl,b_sl] = [null,null,null]
    [d_sl,s_sl,rand_sl] = [null,null,null]
    mouse = [p.mouseX,p.mouseY]
    lastMouse = [0,0]

    p.setup = ->
        p.createCanvas(p.windowWidth,p.windowHeight)
        p.noStroke()
        r_sl = p.createSlider(0,255,100)
        r_sl.position(16,16)
        g_sl = p.createSlider(0,255,0)
        g_sl.position(16,32)
        b_sl = p.createSlider(0,255,255)
        b_sl.position(16,48)
        s_sl = p.createSlider(1,8,4)
        s_sl.position(16,64)
        d_sl = p.createSlider(0,64,32)
        d_sl.position(16,80)
        rand_sl = p.createSlider(0,16,4)
        rand_sl.position(16,96)
        p.frameRate(60)

    p.draw = ->
        p.getInput()
        p.drawUI()

    p.keyPressed = ->
        alt = !alt if (p.keyCode is p.ALT)

    p.getInput = ->
        mouse = [p.mouseX,p.mouseY]
        if (p.mouseIsPressed)
            p.mousePressed()

    p.drawUI = ->
        p.fill(0)
        p.text("Red",150,16+4)
        p.text("Green",150,32+4)
        p.text("Blue",150,48+4)
        p.text("Size",150,64+4)
        p.text("Delta",150,80+4)
        p.text("Rand",150,96+4)
        #p.text("ALT",16,128) if (alt)

    p.mousePressed = ->
        s = s_sl.value()
        [x,y] = [16*s,16*s]
        d = d_sl.value()
        rgb = p.color(
            r_sl.value()+p.random(d)
            g_sl.value()+p.random(d)
            b_sl.value()+p.random(d),127)
        rand = rand_sl.value()
        delta_size = p.random(s/2)
        if (alt) then p.fill(255)
        else p.fill(rgb)
        p.ellipse(
            mouse[0]+p.random(-rand,rand)
            mouse[1]+p.random(-rand,rand)
            x*delta_size,y*delta_size)