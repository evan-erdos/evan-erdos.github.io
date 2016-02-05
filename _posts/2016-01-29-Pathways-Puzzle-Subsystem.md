---
layout: post
title: Pathways Puzzle Subsystem
version: 0.1.2
tag: [Programming, GameDev]
---

The [`Puzzle`][puzzle] namespace in [`PathwaysEngine`][pathways] is now basically functional.
It's a generic framework for the creation of value-holding and state-changing puzzle [`Piece<T>`][piece]s.

A `Piece.IsSolved` when its `Condition` matches its `Solution`.
For a given `Piece<T>`, `Condition` and `Solution` are of type `T` where `T` is an unconstrained type, value or otherwise.

`Piece`s can be `Solve()`d, either by supplying a new `Condition` to see if it matches the `Solution`, or, in the case of an [`Iterator`][iterator], it can be called without arguments to advance the state of the `Piece` in whatever manner the `Iterator` defines.

Not covered on this page are `Responder<T>`s, which link puzzle systems together.
They're not implemented properly yet, and may be superceded by `event` systems in the future.

---


## Interfaces ##

The `PathwaysEngine.Puzzle` namespace defines a few generic `interface`s for puzzle pieces, which can be used anywhere a `Piece<T>` can be used, (typically).
Below are the most important ones.

---


### `IPiece<T>` : **`interface`** ###

An `IPiece` is an element of a larger `Puzzle`, and can change the state of said `Puzzle` on the basis of its own configuration.
It could be solved, unsolved, or in the case of more complicated base types, a piece could represent a digit on a combination lock.
In that case, a given piece might not have its own solution, but could represent a solved puzzle when considered in aggregate.

- `SolveEvent` : **`event`**

    Event callback for inversion of control.
    Inheritors must at least notify subscribers in the event that they are solved, and when they become unsolved.


- `IsSolved` : **`bool`**

    Whether or not the current state is the solution.
    Inheritors which use value types as their generic arguments should enforce the below contract.
    For any inheritors which need to represent more complicated states, implementation should maintain some parity between `IsSolved` and their actual configuration.

    - `ensure` : `IsSolved==(Condition==Solution)`


- `Condition` : **`T`**

    An instance's present configuration.


- `Solution` : **`T`**

    When the configuration of an instance is equal to its `Solution`, it's considered solved.


- `Solve()` : **`bool`**

    Generic approach to solving / resolving aspects of a larger puzzle, or perhaps just one piece.
    The action of solving might represent the pull of a lever, or the placement of a piece in an actual jigsaw puzzle.

    - `condition` : **`T`**
        value to attempt to solve with


~~~csharp
public interface IPiece<T> {

    event OnSolve<T> SolveEvent;

    bool IsSolved {get;}

    T Condition {get;set;}

    T Solution {get;set;}

    bool Solve(T condition);
}
~~~

---


### `IIterator<T>` : **`IPiece<T>, ICollection<IPiece<T>>`** ###

For puzzles where there are sub-groups of `IPiece`s who need to have their state changed on the basis of higher-level components, this allows other classes to deal with this in an abstract way.
If declared on a value type, it will simly operate on those values.
An example of this usage would be if it were declared on `int`: this would likely be representative of a single breaker in a combination lock.
If declared on a reference type (any deriving type of `IPiece` should be the type constraint) then this iterates through those `IPiece`s.

- `Current` : **`IPiece<T>`**

    Represents the next `IPiece` in this collection.
    Has no setter, as this state shouldn't be changed externally.

- `Next` : **`IPiece<T>`**

    Returns the next `T` in the collection.

- `Advance()` : **`IPiece<T>`**

    This changes the state of the iterator, and returns the next element.

~~~csharp
public interface IIterator<T> : IPiece<T>, ICollection<IPiece<T>> {

    IPiece<T> Current {get;}

    IPiece<T> Next {get;}

    IPiece<T> Advance();
}
~~~

---


## Classes ##

The included base-classes can be thought of as implementations of various value types, and are all derived from `Piece<T>` or `IPiece<T>`, its respective interface.
The most interesting ones are described below.

### Base Implementations ###

These classes implement `IPiece<T>` for a few different kinds of value type:

- `Button` : **`Piece<bool>`**

    The `Button` is well-suited for controls which have only two states, and are toggled from one to the other by `Solve()`.

- `Lever` : **`Piece<int>`**

	The `Lever` class represents its `Condition` as an `int`, which corresponds to a particular angle for said lever to be in.
	`Solve()`-ing a lever involves pulling it into the right position, as defined by it's `Solution`.

- `Slider` : **`Piece<double>`** (not yet implemented!)

    Due to the nature of floating-point calculations, this class allows its `Condition` to differ from `Solution` by a third value, `Epsilon`.
    This way, a slider could be considered solved for a range of values, or for a more exact value acceptably close to the `Solution`.

- `WordPattern` : **`Piece<string>`** (not yet implemented!)

    What a neat idea! With `Condition` and `Solution` as **`string`**s, we can compare input to either a particular phrase, or a more general **`Regex`** pattern!

### Collection Classes ###

These classes can be used to aggregate other `Piece<T>`s:

- `Combinator` : **`Piece<T>`**

    Acts on a `List<Piece<T>>` of component pieces, and makes a mapping from `Piece<T>` to `T`, where every piece is keyed to it's solution state.
    The `Combinator` subscribes to its `Piece<T>`s' solved events, and will mark all of them as `IsSolved` when the solution state is achieved, even if the `Condition`s don't match their respective `Solution`s for all the component `Piece<T>`s.

- `Iterator` : **`Piece<T>`**

    For puzzles with an iterative element, this will allow the user to advance the puzzle state of something in a predictable way.
    A good example might be a combination lock, where each breaker needs to be `Solve()`d in order.
    Another example could be a puzzle which uses both a `Combinator` and an `Iterator` to allow for a special solution state, and to allow the said `Collection<IPiece<T>>` to be iterated through.

---


## Events ##

`OnSolve<T>` : **`event`**

Allows for inversion of control, from the lowest piece to the most complex puzzle.
When an `IPiece` is solved, the parent should be notified via this `event`.

 - `sender` : **`T`**

     the `IPiece<T>` sending this event

 - `e` : **`EventArgs`**

     typical `event` arguments

 - `solved` : **`bool`**

     was the `sender` solved?

~~~csharp
public delegate T OnSolve<T>(
    IPiece<T> sender,
    EventArgs e,
    bool solved);
~~~

---


[pathways]: <https://github.com/evan-erdos/PathwaysEngine>

[puzzle]: <https://github.com/evan-erdos/PathwaysEngine/tree/master/Puzzle>

[piece]: <https://github.com/evan-erdos/PathwaysEngine/blob/master/Puzzle/Piece.cs>

[iterator]: <https://github.com/evan-erdos/PathwaysEngine/blob/master/Puzzle/Iterator.cs>

