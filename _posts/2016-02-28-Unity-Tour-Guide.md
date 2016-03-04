---
layout: post
title: Unity Tour Guide
tags: [GameDev]
---

Not knowing how to program can be crippling in the context of game development.
However, Unity has gained popularity by being accessible to non-programmers.
This overview should be helpful for anyone seeking to establish a working knowledge of [Unity][],
without a rigorous understanding of how to program.
It describes methods which can be used to accomplish common tasks in Unity via *utilizing* code,
but not necessarily writing it.


Types
-----

You thought there'd be no programming, huh?
Well, we're dealing with some pretty complicated things today, they're called **`Type`**s,
and without them, none of us would even exist, so let's jump right in.

While the concept of a **`Type`** is definitely a programming thing,
it's also applicable to Unity in general.

Without going into depth, types can be thought of as interpretations of bits.
At the end of the day, any program is sending around ones and zeros,
and types are ways of reading those bits.

Here are some types:

- **`bool`**: a boolean value, `true` or `false`
- **`int`**: an integer! `1.5` is not an **`int`**, `32` is an **`int`**
- **`uint`**: a nonnegative natural number, not frequently used
- **`float`**: a real number, e.g., `1.618f`. Precise, but only half as precise as...
- **`double`**: a more precise real number. In C#, they don't need a type suffix, e.g, `1.618033`
- **`string`**: just text. `"ABC, as easy as 123, as simple as..."`

These are value types, the lowest common denominator.
If something needs a title, it probably defines a **`string`** somewhere in code.
If a player needs `3` lives, there's an `int` somewhere,
and if a timer has `59.535` seconds left, it's using a **`float`** or a **`double`**.

These are very simple, however, there are more complicated value types, known as `struct`s.

The Unity API defines a few:

- **`Vector2`**: just x and y
- **`Vector3`**: a set of 3 **`float`**s, typically used for positions and forces, etc.
- **`Vector4`**: a 4-dimensional vector! wow! (not frequently used)
- **`Quaternion`**: the weirdest one yet! Unity uses **`Quaternion`**s to store rotation,
    because they have some weird mathematical properties that make calculations faster,
    and also prevent gimbal lock. Super weird, don't worry about how they work.

Unity makes heavy use of reference types.
A reference is similar in concept to a pointer, insofar as it "points" to some code object.
Most Unity objects ([**`Component`**][component]s, [**`GameObject`**][gameobject]s, et al)
are instances of reference types.
In the same way an **`int`** refers to a particular integer,
a variable of type [**`GameObject`**][gameobject] is a reference to a particular object in the scene.

Moreover, classes can inherit behaviour from less-derived types.
Most of the classes in the Unity API extend their functionality from other classes,
and understanding the relationships between these derived classes is critical.


Object Hierarchy
----------------

When I try to learn something,
I find it most helpful to have a good concept of its overarching structure.

Every script a programmer writes is derived from a class called [**`MonoBehaviour`**][monobehaviour],
and then their code extends the functionality of the base [**`MonoBehaviour`**][monobehaviour].

The hierarchy is as such:

- **`UnityEngine.Object`**:
    - [**`GameObject`**][gameobject]
    - **`ScriptableObject`**:
        - [**`Component`**][component]:
            - [**`Transform`**][transform]
            - **`Rigidbody`**
            - **`Collider`**
            - **`Camera`**
            - **`MeshFilter`**
            - **`Renderer`**
            - **`Light`**
            - **`AudioSource`**
            - **`AudioListener`**
            - **`Animator`**
            - [**`Behaviour`**][behaviour]:
                - [**`MonoBehaviour`**][monobehaviour]

[**`GameObject`**][gameobject]s can be thought of as collections of [**`Component`**][component]s.
A [**`GameObject`**][gameobject] always has one [**`Component`**][component],
its [**`Transform`**][transform],
and any script you write can be attached to a [**`GameObject`**][gameobject],
just like any other [**`Component`**][component] is attached.
Any fields exposed by a [**`Component`**][component] will appear in the Editor.

---

More to come!


[unity]: <http://docs.unity3d.com/Manual/index.html>
[gameobject]: <http://docs.unity3d.com/ScriptReference/GameObject.html>
[component]: <http://docs.unity3d.com/ScriptReference/Component.html>
[transform]: <http://docs.unity3d.com/ScriptReference/Transform.html>
[behaviour]: <http://docs.unity3d.com/ScriptReference/Behaviour.html>
[monobehaviour]: <http://docs.unity3d.com/ScriptReference/MonoBehaviour.html>
---












