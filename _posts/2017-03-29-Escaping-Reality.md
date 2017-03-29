---
layout: post
title: Escaping Reality (CClub Talk)
tags: [GameDev]
---

Escaping Reality: VR from Sci-Fi to Practice
--------------------------------------------

### Introduction ###

Hello, and welcome to "Welcome to Reality with Ben Scott" with me, Ben Scott.

---


#### Overview of Terms ####

* Hey so what the *fuck* even is VR?
    * ok, for starters, let's keep it civil
    * VR is both the broad category and a specific category within itself
    * there's going to be a lot of this sort of thing, so start taking notes

* Hey so anyways what the *actual fuck* is "VR"?
    * VR is a type of "VR" where your entire reality is supplanted by digital media
    * head-mounted-displays are ubiquitous in VR and in "VR"
    * Stereoscopic rendering is really quite common across all of "VR", not just in VR
    * head tracking is a hard-and-fast requirement, a cornerstone of VR *and* "VR"
    * 3D motion controllers are pretty dang cool, I personally think they're required
    * Some of us would consider spatialized audio to be critical to VR, but not "VR"

* Hey could you make the broader category of "VR" like, I don't know, *more* confusing?
    * No. In VR as in life, nothing in the world makes sense anymore,
      actions don't have consequences, effects don't seem to follow causes,
      and my best working theory is that we're living in a simulation,
      authored by some kind of all-powerful deity who likes postmodern science fiction
    * *If virtual reality is wrong, I don't want to be right*

---


#### Has VR ever happened before? ####

* reality didn't exist until the 1940s
    * then came "postmodern-ish" sci-fi, e.g. *Ubik* (Philip K Dick)
    * also a part of *Do Androids Dream of Electric Sheep?* that wasn't in *Bladerunner*
    * *Star Trek* had the *HoloDeck*, a room-scale? whatever-scale VR space
    * *Starship Troopers* (Heinlein) had some sort of AR going on with those suits

<video src="https://www.youtube.com/watch?v=ISJWZpFIAlQ" autoplay nocontrols></video>

* virtual reality was invented in 1966
    * brought to you by ya boy Ivan Sutherland
    * I met Ivan Sutherland last year at Carnival holy shiiitttttttt
    * the initial experiment was called "The Sword of Damocles"
    * why? because you literally strap a damn CRT monitor to your face,
      using an engine hoist so it doesn't shatter your spine

* virtual reality happened in the 90s too, so radical!
    * (this section really doesn't need content,
      I'll just play the Dactyl Nightmare 2 video *in its entirety*)

<video src="https://www.youtube.com/watch?v=L60wgPuuDpE"></video>

---


#### Interface / Experience / "User Temperament Problems" ####
* why oh why would such a wonderful thing not take off in 1990?!
    * it weren't so great, as you still had to strap a CRT to your face
    * (Sometimes they didn't have to use a engine hoist, though!)
    * framerate was literally the worst, graphics were *literally* the worst

* people *still* have a hard time acting right in VR
    * wait patiently as I go on a rant or two about laser pointers and exit burritos
    * people *never* turn around in VR, it's always "oh, look at all this stuff in view!"
    * VR can have real, measurable, physical effects on people
        * I tried to start a research project once to study the physical effects:
            * the hypothesis was that people would get pushed off ledges in VR
            * then we'd push people off ledges in *real life*
            * then we'd push people off ledges in VR *and* in real life
        * I'm not fantastic at science

---


#### Rendering Pipeline + Hardware ####

* it's just all so confusing! How does it work?
    * brief, *brief* review of 3D graphics
    * rushed, ad-libbed explanation of how eyes work
    * refer to infographic of 3D graphics going into eye sockets
    * something something distance-based flattening, single-pass render, next slide
    * gloss over a point about focal distance because the 3D graphics took too long

* Has to render two perspectives, sometimes four if you're lucky
    * so it takes a *grizzly* GPU to be able to do things properly
    * like, such as this GTX 1080, of which the club has two!
    * not just sometimes 4x the load, but twice as fast, refreshes at 120 Hz

* "6 juicy hacks for the modern graphics programmer (Number 3 will bore you!)"
    * [Distance-Based Flattening][flat]
        * beyond a certain distance (conservatively, 100m) perspective stops mattering,
          so the discerning rendering pipeline will only render stereoscopically for 100m
    * [GPU Flushing][flush]
        * to keep the framerate above a certain threshold (avoiding pipeline "bubbles"),
          some renderers up and flush the GPU at the end of the frame
        * this ensures that the card is always fed draw calls in a timely fashion
    * [Frame Interpolation ("TimeWarp ©®™")][warp]
        * applies some kind of transformation to the image between cycles,
          to allow extremely rapid recalculations of the frame if the head moves
        * will also render and store to a buffer the pixels outside the user's FOV
        * difficult to warp pixels in a nearly accurate way


* "Wow, that's an extremely low-level graphics thing they're doing there!"
    * fun fact, John Carmack works at Oculus

---


#### Ben Scott's Laws of VR Dev - Speed Round ####

* VR Dev Law #1: The Shia LaBeouf Principle®
    * the most important thing is to just get in there and build something
    * people love to think "Oh, I can design this from afar! Oh, that aught to work!"
    * people who think like that are *wrong and should feel ashamed*

* VR Dev Law #2: Stay Outta My Personal Space®
    * it's a "3D" display, don't stick a bunch of nonsense in peoples' faces
    * when allowing a 3rd person perspective in a spaceship / driving game,
      be aware that dirt and exhaust get in your face and is gross
    * everything should be at least 0.5m from the Player's face

* VR Dev Law #3: Substance Abuse is Fine®
    * Physically Based Rendering / Shading (PBR) is clutch AF in VR
    * PBR approximates real, physical materials that have surface details
    * without them it's impossible to gage if an object is spinning / far away
    * flat shading can *take a bracing shot at the moon* for all I care

* VR Dev Law #4: So Maybe Sometimes Do Not Throw People off Ledges®
    * not all people are trapeze artists
    * just leave the player's camera in mostly the same place if you can
    * don't spin them around or throw them off... too many ledges


[flush]: <http://vrerse.com/wp-content/uploads/2014/05/TheLabRenderer.pdf>
[flat]: <http://jov.arvojournals.org/article.aspx?articleid=2122030>
[bubbles]: <http://www.ingenia.org.uk/Content/ingenia/issues/issue61/edwards.pdf>
[warp]: <https://developer3.oculus.com/documentation/mobilesdk/latest/concepts/mobile-timewarp-overview/>



