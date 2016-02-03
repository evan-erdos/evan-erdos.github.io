---
layout: post
title: Using C#6.0 in Unity 5
tag: [Programming]
thumb:
  start: /rsc/thumbs/csharp-thumb.png
  hover: /rsc/thumbs/csharp-hover.png
---

C#6 presents a score of new and delicious syntax sugars,
and can be compiled into .NET 2.0-compliant bytecode.
This means it has implications for Unity Developers,
and the overall health and wellbeing of their code.

A few of the fancy features are unusable, but on the whole, it works well.
In fact, my game engine, [`PathwaysEngine`][pathways], uses it pretty heavily,
and I haven't seen any code-related issues when using it,
aside from a few features which don't work, but also don't cause bugs.


Alex Zhdankin's [repository][] holds a template project / installer for his custom C#6.0 compiler.
Instructions can be found there.
Once installed, any `*.cs` file in the project will be able to make use of the fancy new syntax sugars present in the C#6.0 spec.

Two of the listed features of C#6.0 cannot be used in Unity as of `2015-01-29`.
Primary constructors cannot be used either, as they were not included in the final language spec.

First, `async` stuff is really weird, and I don't understand it.
There are, apparently, some limitations to its use.

Secondly, the `using static MyNamespace.MyClass` syntax cannot be used on any attachable scripts.
Ordinarily, it would allow the compiler to import the `static` methods and properties from another source file, and it does achieve this!
It works fine in management scripts, and in runtime classes which do not need to be attached to any in-scene `GameObject`s.
However, using it will break Unity's classname checker if used on an attachable script.

The rest of the tasty, delicious features can be used as follows.

---


## Null-Conditional Operator ##

As with any language, `NullReferenceException`s are the bane of every Unity programmer's existence.
However, the null-conditional operator can both prevent `NullReferenceException`s from occurring, and also clean up what would otherwise be very messy `null` checks.

A shining example of how useful this is in Unity programming is such:

```csharp
    var audio = GetComponent<AudioSource>();
    if (audio==null) audio.Play(); // whoops!
```

How often do we have to poke around looking for `Component`s, and how often do they not exist, or exist somewhere else we didn't expect?
Almost all the time.
With C#6, this whole mess can be rewritten as such:

```csharp
    GetComponent<AudioSource>()?.Play();
```

Presuming that we don't actually need the reference for later, this works fine, and also avoids a nasty `NullReferenceException` in the event that we forgot to add an `AudioSource` to the `GameObject`.

While I don't frequently use built-in arrays anymore, if I did, I'd use this operator to ensure I didn't try to index into something that turns out to be `null`.

```csharp
    int[] arr; //= new int[3];  // whoops!
    int? n = arr?[2];
```

Sure, `n` will be `null` too, but it's still helpful.
I would argue that the best usage of this operator is when writing `delegate`s.
It's used in my source code.
In prior versions of C#, there was no way to safely invoke a `delegate` without writing a null-check first. Now, it can be written as such:

```csharp
    OnMyEventChange?.Invoke(this, EventArgs.Empty, value);
    // or whatever arguments match the delegate
```

The Unity Editor's UI *only* allows built-in arrays to be assigned to from the editor.
When other `Component`s need to be added in the editor, the forward-thinking programmer has to copy them into dynamic `List<T>`s, but what if the editor assigns something to null, or some designer decides to change the length?
Both of these scenarios happen all the time.
However, this nice little operator can prevent bad things from happening when they do.

---


## Expression-Bodied Functions & Properties ##

This is my favourite.
It allows simple methods and get-only properties to be written with the effortless wave of an arrow.
These are particularly nice when writing lots of tiny things for the `MonoBehaviour` event callbacks like `Update()` or `OnTriggerEnter()`.

Additionally, I love using properties because C# allows them to be declared in `interface`s, which is super powerful.
Expression-bodied functions have almost the same syntax as anonymous functions do, but are explicitly bound to the class they're defined in (unlike anonymous functions).

In my command-driven event system, I have defined a number of verbs, and all the classes which can have those verbs done to them inherit an interface to allow them to do so.
If a class inherits from `IReadable`, for example, it can be read by the user.

```csharp
    public bool Read(lit::IReadable o) => o.Read();
```

Due to the nature of these verb-events, I often end up with lots of simple functions like this, which simply pass along commands from the `Player` to `IReadable` instances nearby.

A more complicated example would be the `Person.GetNearby<T>()` method.

```csharp
    public static List<T> GetNearby<T>(
                    Person person,
                    string filter,
                    ref List<T> list)
                        where T : Thing =>
        GetNearby<T>(filter, ref list,
            GetNearby<T>(
                person.Radius,
                person.Position));
```

Especially with recursive or multiply-overloaded calls like this, this syntax is pretty tasty.

Even tastier are get-only properties, which can be included in `interface`s.
Here's another example from `Person`.

```csharp
    public override Vector3 Position => motor.Position;
```

Here, `Person` simply forwards its `motor`'s `Position` to the outside world.
`Person` could easily inherit from `IMotor`, and could then be manipulated and dealt with by other code without having to typecast or having to pass around a reference to its `motor`.

---

### String Interpolation ###

Finally, C#6 has a syntax feature called string interpolation.
This allows for in-scope variables and references to be used directly in a `string` template, without having to go through the awful business of using `string.Format` for the same task.

There are honestly things I've been able to do with string interpolation that I wouldn't have been feasible without a whole lot of awful hacks.
String interpolation makes all of these things a breeze.

I use these heavily in the `Literature` namespace, which deals with text input and display.
Here's and example from `Description`:

```csharp
public virtual string Template => $@"
    ### {Name} ###
    {init}{raw}

    {Help}";
```

This uses string interpolation to make a `*.md` template for the description.
A special formatter elsewhere renders it into the Unity RTF subset.

In the same file, I have a `Nouns` property, a `Regex` which matches whatever it's assigned to, and also the exact name of the instance, just in case the user decides to type it all out.

```csharp
    public Regex Nouns {
        get { return nouns; }
        set { nouns = new Regex((Name!=null)
            ?$"({Name})|{value}":$"{value}"); }
    } Regex nouns;
```
This way, the `Regex` matches both the full name, and all the assigned nouns (only if the name is defined!).


---

[pathways]: <https://github.com/evan-erdos/PathwaysEngine>

[repository]: <https://bitbucket.org/alexzzzz/unity-c-5.0-and-6.0-integration/src>

