---
layout: post
title: "<code>${talk_title}</code>"
tags: [GameDev, Writing]
---

Hello, everyone, and welcome to `${talk_title}`!

---

### Introduction ###

I've been doing talks like this for a long time now.

I did this on one (1) other occasion, so I've got it down to a science.

I'm doing a talk about `${talk_subject}`!
To start `${talk_verb}`ing `${talk_subject}`,
you'll need to get the ${talk_sample_project}!

The sample project is on [GitHub][], but can also be downloaded here:

- [Sample Project][] *(v1.0.0, 37kB, probably, I didn't count)*

Now you're ready!

---


### What is CoffeeScript? ###
It's JavaScript. Next.


### What does `${talk_subject}` do? ###
It makes JavaScript less bad than JavaScript.


### Why should I use `${talk_subject}`? I've heard bad things about-- ###
--Yeah, well, who cares? It works just fine.
If they stopped developing the compiler tomorrow,
you could just continue to write in the language.
You shouldn't be writing large, complicated projects with it
(hey, how's that going, Atom?),
but for `${practical_applications_of_talk_subject}`, it's perfectly nice and easy to use.

### What kind of `${practical_applications_of_talk_subject}`? ###
Fancy you ask!

You can use it with existing JS libraries, like `P5.js` or `THREE.js`,
and make super neat WebGL Solar Systems that run on your phone.

### how can we be so great and awesome, ben scott? ###
Fancy you ask!

### How do I do `${fancy_nonsense_related_to_talk_subject}` with this? ###
Fancy you ask!
There's no shortage of web developers with lots of time on their hands.
If you want to write big, complicated webapps,
try [Spine][] or [Backbone][] or something.
What do either of those do? I'm not sure. They say they're MVC for JS.
If that means something to you, check it out.


### How do I do fancy render things like this? ###
This example uses [THREE.js][three], a JavaScript framework for 3D stuff.
Go figure.


### *Look Under Your Seats* ###

The [Sample Project][] *(v1.0.0, 37kB or something)* is organized as such:

~~~
├── LICENSE
├── README.md
├── assets
│   ├── blue-albedo.png
│   ├── gas-giant-albedo.png
│   ├── gas-giant-normal.jpg
│   ├── gas-giant-specular.png
│   ├── planet-albedo.png
│   ├── planet-normal.jpg
│   ├── planet-specular.png
│   ├── sun-albedo.png
│   ├── vulcain-albedo.png
│   ├── vulcain-normal.png
│   ├── vulcain-specular.png
│   └── vulcain.js
├── code
│   ├── lib
│   │   ├── OrbitControls.js
│   │   ├── coffee-script.js
│   │   ├── perlin.coffee
│   │   ├── three.min.js
│   │   └── viewer.coffee
│   └── space.coffee
├── index.html
└── style.css
~~~

We've got a bunch of stuff in there.

Everything in `assets/` is a texture, minus `vulcain.js`,
which is a specially converted 3D model of a rocket engine.

Most materials / shader models use texture maps of various sorts.

Here, we're using:

- `albedo`:
    Albedo maps represent the primary color of a given thing.
    If your albedo map is red, your thing is red. Next.

- `specular`:
    Specular maps define the reflected color of something.
    Most materials reflect some shade of gray,
    and that color is very dark for all but the shiniest things.
    Metals (and other reflective surfaces)
    can be represented by dark `albedo` maps and brighter `specular` maps.

- `normal`:
    Normal mapping is a quick and dirty way of giving a surface some bumps.
    It informs the lighting model how to light the surface,
    as if it had some ups and downs.
    Normal maps do cheaply what [Displacement Maps][disp] do for real.



The important thing is that it can render stuff to a HTML `canvas` node.

~~~html
<div id="CoffeeCode" class="mainContainer"></div>
<script src="code/lib/three.min.js"></script>
<script src="code/lib/OrbitControls.js"></script>
<script type="text/coffeescript" src="code/space.coffee"></script>
<script type="text/javascript" src="code/lib/coffee-script.js"></script>
~~~

This is all the HTML you need to worry about.


~~~html
<div id="CoffeeCode" class="mainContainer"></div>
~~~

This is where we're going to put the new canvas node:
in the designated CoffeeCode `div`.


~~~html
<script src="code/lib/three.min.js"></script>
<script src="code/lib/OrbitControls.js"></script>
~~~

These are some libraries. You'll need them around to run this whole deal.

~~~html
<script type="text/javascript" src="code/lib/coffee-script.js"></script>
~~~

Take note, this is an awful thing to do.
We're loading the entire CoffeeScript "compiler" when we load the page.

There's a hundred ways to do this ahead of time,
this is only here out of convenience.


~~~html
<script type="text/coffeescript" src="code/space.coffee"></script>
~~~

This refers to whatever script you're writing, in our case, `space.coffee`.
Notice the `*.js` there at the end, specifically that it says coffee.
While you *can* run CoffeeScript directly, you *should* compile it first.
Many common utilities compile the CoffeeScript, then look for `*.js` files.


Since I use a GitHub Pages website, Jekyll does that for me.
There's a "compiler", and a bunch of other things that do this.

### What does the webpage look like when it's set up? ###
Excellent Question, Tim!

~~~html
<body style="background-color:#000">
<div id="CoffeeCode" class="mainContainer">
    <canvas width="944" height="583" style="width: 944px; height: 583px;"></canvas>
</div>
<script src="code/lib/three.min.js"></script>
<script src="code/lib/OrbitControls.js"></script>
<script type="text/coffeescript" src="code/space.coffee"></script>
<script type="text/javascript" src="code/lib/coffee-script.js"></script>
~~~

The only difference is that we've made a `canvas` node,
and made it a child of the `div` we were looking for.
Then, the framework renders all its nonsense into the `canvas`.

This is all we need to worry about, insofar as HTML is concerned.

Now, let's write some CoffeeScript!

### CoffeeScript and You ###

Here's A variable!

~~~coffee
myVariable = 'A'
~~~

Here's a function!

~~~coffee
myFunction = (args) ->
  console.log "That thing you passed me is #{args}!" if args?
~~~

We're logging a message, but only if `args` is non-null and not undefined.
That there is the existential operator, and it's your friend.
Also, that string there is interpolated.
Double quoted strings can have any in-scope variable inserted into them via the `"#{myVar}"` syntax.
Also, the `if` came after the statement.
This is because everything[^0] is a returnable expression!

Anywhere you could omit braces in a C-like language,
you can put a control flow statement after something in CoffeeScript.

[^0]:
    Not everything is a returnable expression.
    Anything that could sensibly be a returnable expression is such.

~~~coffee
myFunction = (args) ->
  return unless args?
  console.log "#{args} exists, for sure!"
~~~

This is a nice little pattern here.
How often do you want to make sure the arguments actually exist?
This function will terminate if `args` is `undefined` or `null`,
but will otherwise continue evaluating the function.
The `unless` keyword is simply `if not`.
I find this to be cleaner than it's equivalent in another language:

~~~cpp
void myFunction(string[] args) {
    if (args=="" || args==null) {
        return;
    }
    for (int i=0; i<whatever; ++i) {
        cout << args[i];
    }
}
~~~


### *Just CoffeeScript Things* ###


~~~coffee
class MyClass
  constructor: (params = {}) ->
    @params = @myMethod(params)

  myMethod: (n) -> n**n # square figuratively anything

~~~

Ok, so, also, classes exist. Don't let it get to you.

There's a lot going on here:

1. `@` is an alias, and is converted to `this.`
2. `@params` is just like `this.params` in JavaScript
3. `@params` is declared in that statement, it's an instance property
4. `@myMethod` is an instance method


You can have class methods, too.
They're declared like this.

~~~coffee
class MyClass
  constructor: (@params) ->
    MyClass.myMethod(3)

  @myMethod: (n) -> n**n
~~~

Also notice that there's a `@` in the constructor now.
It automatically creates the property on the class.

#### Syntax Sugars ####
For loops are returnable expressions!

~~~coffee
f = (n) -> n**n # square literally anything!

map = (f(x) for x in [0,1,3,-4,5,11] where 0 < x <= 5)

# => "whatever all that comes out to"
~~~

Destructuring argument + heregex literals! (from the [Cookbook][])

~~~coffee
pattern =
  ///\b
    \(?(\d{3})\)?  # area code
    [-\s]?(\d{3})  # prefix
    -?(\d{4})      # line number
  \b///g

[area_code, prefix, line] = "(555) 123-4567".match(pattern)[1..3]

# => ['555', '123', '4567']
~~~


---

### A Short Review of the Code ###
Wow, that was quick!


### Workshopping Improvements ###
Ok, someone tell me how to:

- use Perlin noise for the stars, instead of random distribution!
- import other 3D models!
- have the planets follow proper gravitational paths!
- something else!


---

[github]: <http://github.com/evan-erdos/webgl-solarsystem/>
[sample project]: <https://github.com/evan-erdos/webgl-solarsystem/archive/1.0.0.tar.gz>
[spine]: <http://spinejs.com/>
[backbone]: <http://backbonejs.org/>
[cookbook]: <https://coffeescript-cookbook.github.io/chapters/regular_expressions/heregexes/>
[disp]: <https://en.wikipedia.org/wiki/Displacement_mapping>
[three]: <http://threejs.org/>


