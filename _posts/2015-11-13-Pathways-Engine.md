---
layout: post
title: Pathways Engine
version: 0.1.0
tag: [Programming, GameDev]
---

>[An Adventure Game engine with an Interactive Fiction inspired twist!][pathways]

[pathways]: <https://github.com/evan-erdos/PathwaysEngine/>

This `PathwaysEngine` I just released right now is the culmination of my efforts to create a game engine.
It has aspects of [FPS][]s, [RPG][]s, and, perhaps uniquely, [Text Adventures][].
Movement and Cameras are controlled by the typical "WASD" & Mouse, but more advanced input is achieved through a text-based command line.
The source is written in [C#][], and targets [Unity][], a common game development engine.
Below is an overview of the namespaces, and some other important information.

[FPS]: <http://en.wikipedia.org/wiki/Marathon_Infinity>
[RPG]: <http://www.spiderwebsoftware.com/geneforge/>
[Text Adventures]: <http://ifdb.tads.org/viewgame?id=6dj2vguyiagrhvc2>
[C#]: <http://www.mono-project.com/docs/about-mono/languages/csharp/>
[Unity]: <http://unity3d.com>

---

## Structure ##

The engine is split into a few sub-namespaces of the main `PathwaysEngine` namespace, each having its own vital function.

- `PathwaysEngine.Adventure` : **`namespace`**

    One of the largest namespaces in the engine, and with the class hierarchy among `Actor`s, the `Parser` class and all related text-interface aspects of the engine (it's namespace alias is `intf`, short for "Interactive Fiction").

- `PathwaysEngine.Movement` : **`namespace`**

    Deals with the mathematical & effect-based subsystems which define how the `Player` & other `Actor`s move, make sounds, animate, and interact, physically.

- `PathwaysEngine.Libraries` : **`namespace`**

    This namespace contains very generic library & framework code, external libraries, and other loose ends. Be aware that code in this folder is not necessarily part of the `PathwaysEngine`, and may not even be in the namespace.

- `PathwaysEngine.Inventory` : **`namespace`**

    Deals with items, their abilities, and the inventory window UI.

- `PathwaysEngine.Statistics` : **`namespace`**

    Handles all statistical combat / event interactions, including all manner of powers, abilities, dice rolls, and resistances.

- `PathwaysEngine.Utilities` : **`namespace`**

    Deals with Everything else. This class contains things suchas user input controls, via the `Control` class, variouscamera scripts, and misfits from other namespaces.


More to come!
