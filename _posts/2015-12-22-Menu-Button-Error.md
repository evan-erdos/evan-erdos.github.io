---
layout: post
title: The Menu Button Error
tag: [Programming, GameDev]
---

> [Today I fixed the most comical bug I've yet come across in my (admittedly short) tenure as a programmer.][bug]


[Blades of Exile][] is the only game by [Jeff Vogel][] that has been open-sourced, and I (very infrequently) contribute to its development (I made the [icon][], for example).
This very small bug fix is a shining example of my typically underwhelming level of involvement in the project.

I fixed the bug by adding `7` after the `3`:

~~~cpp
   play_sound(3, time_in_ticks(5));
~~~

The game ran just fine without my fix.
There were no unusual behaviours, no graphical errors, and most importantly, all the *other* sounds played as expected.

The game begins with a retro 3D rendering of an adventurer, paired with a dramatic theme song.
This raycasted explorer gazes wistfully over the distant mountains, steeling himself for whatever it is that adventurers usually steel themselves for whilst looking around fantasy settings.

The only issue was that the second digit of this number had gone missing.

Whereas sound `37` could be considered a perfectly reasonable clicking noise for a menu button to have, sound `3` would assuredly not be considered a reasonable clicking noise by anyone, under any circumstances. Moreover, it was longer, and would be cut off at unusual times by the function.

All of this resulted in a wonderfully anticlimactic error, because once the title sequence had ended, and once the dramatic theme song had run its course,

> Any time you clicked a menu button, it would sneeze at you.

---
<video controls>
	<source src="https://cmu.box.com/shared/static/4ornfbh1aag1et5led9nn2dgoyyce1ik.mov">
</video>
---

_Start Scenario **achoo!**_

_How to Order **blaerch!**_

_Create New Party **snarfch!**_

[bug]: <https://github.com/calref/cboe/pull/49>
[icon]: </CBoE-Icons/>
[Blades of Exile]: <http://www.spiderwebsoftware.com/blades/opensource.html>
[Jeff Vogel]: <http://jeff-vogel.blogspot.com>
[Spiderweb Software]: <http://www.spiderwebsoftware.com>
