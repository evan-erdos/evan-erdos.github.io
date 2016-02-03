---
layout: post
title: Sudoku Reimagined
tag: [GameDev]
thumb:
  start: /rsc/thumbs/sudoku-thumb.png
  hover: /rsc/thumbs/sudoku-hover.png
img: https://cmu.box.com/shared/static/6kz0y6rn8sfr25knfieug1tv12emje7k.png
---

Sudoku is a great brain teaser, but mental math is boring.
Numbers are cool, but who needs them?

A few alternatives could easily replace the numbers on a Sudoku board,
while maintaining the core problem solving fun of the original game.

---

One option could be to use color.

Hexadecimal color values can be summed, just like numbers.
A program could also perform more complex and nuanced operations on these color values, providing a level of abstraction that wouldn't be possible on paper.
However, using too many colors could become ambiguous or confusing.
It could also make solving the board too complicated to reason about.
For instance, how many people would be able to intuitively determine what the difference or product of two colors would be?
It might be acceptably difficult to determine this with reference of a color wheel, or with very generic, simple colors, however, this presents another problem.
How would the UI of a system like this allow users to input colors in any meaningful or ergonomic way?
For these reasons, colors would be a difficult replacement.

---

Another option would be to use logical patterns.

It's a fair challenge to determine the "difference" of two patterns.
Moreover, this mental computation could be done, more or less, at a glance.
This could make for a very fast, and also very difficult puzzle.
Applying a spatial pattern mechanic to the usual Sudoku board wouldn't be effective, as there may not be enough visual structure or hierarchy, and as such, it could become confusing.
These patterns would need to be clearly identifiable and distinguishable, while simultaneously being complicated enough to use as puzzle pieces.
Moreover, the relationships they need to fulfill should be rather simple.
It's difficult enough to remember what the composition of a bunch of patterns would be, without having to worry about the "big picture".
In Sudoku, the "big picture" would be that the rows and columns also need to sum properly.
I argue that with more complicated patterns, the goal should not be to achieve a particular goal, but rather to avoid a particular state of the game.
Instead of having to construct a filled-in square from multiple sections, the goal should be to ensure that none of them intersect.

The exact logic of this puzzle could be interchangeable.
Perhaps there are many spatial relationships which serve as good puzzle mechanics.
Perhaps the goal is elimination, where the user must place patterns on the board in such a way that their intersection leaves no individual "slots".

---

While playtesting would reveal the most fun versions and operations of the pattern-based puzzle, the idea of patterns doesn't necessarily need to be two-dimensional.

The most interesting form of this puzzle could involve 3D patterns, and reasoning about how they could be solved, in any of the above gameplay modes.

![dimension][]

In this simple example, the goal would be to ensure that the patterns in the constituent cubes *and* the rows or columns don't intersect.
In this particular example, I've elected to have the board be only one level deep, as opposed to being a whole cube.
The level of difficulty for this many shapes, with another 3 columns deep would probably be too much, or not even geometrically solvable.

Having it be a single level (even though the puzzle piece patterns themselves are 3D) would allow for a rather intuitive keyboard-based input scheme.
The user would select a piece to play, and then simply type coordinates, e.g., "c6" for the third row, 6th column.
While having users type is possibly not ideal, a skilled player could iterate very quickly, trying many pieces in many different places by rapidly typing coordinates, and then "enter" or "delete", to place or remove patterns.

---

[dimension]: <https://cmu.box.com/shared/static/6kz0y6rn8sfr25knfieug1tv12emje7k.png>

