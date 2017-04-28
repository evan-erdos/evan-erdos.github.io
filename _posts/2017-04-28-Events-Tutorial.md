---
layout: post
title: On Using Serialized Events with Builtin C# Events
tags: [GameDev]
---

This is the most powerful design pattern in Game Development.
It has two parts: The standard underlying C# `event` system,
and a special one-line class derived from `UnityEvent<T,U>`:

~~~csharp
/// GameAction : (sender, args) => void
/// standard event delegate for commands
/// - sender : the object which is issuing the command
/// - args : standard event arguments
public delegate void GameAction(IObject sender, GameArgs args);

/// GameArgs : EventArgs
/// a common base argument structure for all event arguments
/// - pattern : an expression for matching against objects
/// - input : raw textual description of object from input
/// - goal : intended target of action or event
public class GameArgs : System.EventArgs {
    public Regex Pattern {get;set}
    public string Input {get;set;}
    public IObject Goal {get;set;}
}

/// GameEvent : UnityEvent
/// a serializable event handler to expose to the editor
[Serializable] public class GameEvent : UnityEvent<IObject,GameArgs> { }
~~~

Now, there's plenty going on here, but there are three main parts:

1.  The `GameAction` delegate defines the signature of the event function.
    All events should follow the same pattern of sending the `sender`,
    which is a reference to the object which raised the event,
    and the `args`, which will be an instance of the following class:

2.  The `GameArgs` class is a special class derived from `EventArgs`,
    which encapsulates all the basic information required by the event.

3.  The `GameEvent` class is the one that serializes the event in editor.
    Editor serialization is the reason why this design pattern is amazing.

This is a simple interface to a simple object which can be `View`-ed.
Built-in C# events can be required by interfaces, which is very nice.

~~~csharp
/// IObject : ILoggable
/// provides a common interface all things
public interface IObject : ILoggable {

    /// Name : string
    /// an identifying string for this object
    string Name {get;}

    /// Position : (real,real,real)
    /// represents the object's location in world coordinates
    Vector3 Position {get;}

    /// ViewEvent : event
    /// raised when the object is observed
    event GameAction ViewEvent;

    /// View : () => void
    /// views this object, and raises the view event
    void View();

    /// Do : () => void
    /// invokes the default verb, e.g., drop items, read books
    void Do();
}
~~~

Now, anything which derives from `IObject` has a `View` event.
Subscribing to events is tantamount to adding a callback to the event,
and the typical method of creating a temporary subscription is as such:

~~~csharp
GetObject().ViewEvent += (o,e) => print($"The {o.Name} was seen!");
~~~

This works well for C# events, but we want that fancy editor stuff too.
This next step is what ties the two event systems together:

~~~csharp
class Thing : MonoBehaviour, IObject {
    [SerializeField] protected GameEvent onView = new GameEvent();
    public event GameAction ViewEvent;
    void Start() => ViewEvent += (o,e) => OnView(o,e);
    void OnView(IObject o, GameArgs e) => onView?.Invoke(o,e);
}
~~~

With the event exposed in the editor, it can execute arbitrary code:
![editor-event.gif][](We Can Do Literally Anything For You, Wholesale!)

IMHO, this is truly the most flexible pattern in Game Development.
It allows programmers to expose key gameplay events to the editor
(and therefore, to both designers and their fellow programmers)
and it provides a quick and reckless way to organize interactions.
In a sense, it mirrors the way game designers talk about gameplay:

> And then, like, the bad guys all die when the one guy dies,

> and then there's, like, an explosion, and the fusion core blows up!

> ... then a bunch of rabid dogs show up, and eat everyone!


That script would otherwise be an error-prone, spaghetti-riddled mess,
but the serialized events allow extraneous things to happen `OnKill()`,
`OnFusionCoreExplosion()`, `OnRabidDogAttack()`, `OnWhateverYouPlease()`.

[editor-event.gif]: <https://cmu.box.com/shared/static/gyhxd3yb933klmkdt46lekwp201v7cwl.gif>
