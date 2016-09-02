---
layout: post
title: Decompiling Pokémon Go
tags: [Programming, GameDev]
---


### Abstract ###
Given how competitive the field of mobile game development is,
and given that [Java is very easy to decompile][0],
you might wonder if a clever developer could get their paws on some juicy trade secrets.


**Question:** Is Pokemon Go safe from reverse-engineering?

**Answer:** *NO! It is super not safe from that!*


### Introduction ###
In my short tenure as a mobile game developer,
I've learned two important pieces of information:

1. Java is *the worst*
2. specifically, [Java is very easy to decompile][0]
5. I'm not the best with numbered lists
3. Android apps, e.g., `*.apk` files, are just zip archives
6. `*.apk` files contain Java, and [Java is very easy to decompile][0]


### Procedure ###
With the knowledge that [Java is very easy to decompile][0],
I set out to try to get the source code for Pokemon Go.
Turns out, it's not really all that difficult.
There are about 3 steps:

1.  [Get Pokemon Go][1], specifically the `*.apk` file, for Android
    ![download.png][]

2.  unarchive the `*.apk` file, change the file extension if you must
3.  Oh, boy! Look'it what we got here!

    ~~~
    .
    ├── AndroidManifest.xml
    ├── META-INF
    │   ├── CERT.RSA
    │   ├── CERT.SF
    │   └── MANIFEST.MF
    ├── assets
    │   └── bin
    │       └── Data/
    ├── classes.dex
    ├── lib
    │   └── armeabi-v7a
    │       ├── libNianticLabsPlugin.so
    │       ├── libil2cpp.so
    │       ├── libmain.so
    │       ├── libunity.so
    │       └── libvrunity.so
    ├── res
    │   ├── anim/
    │   ├── color/
    │   ├── drawable/
    │   ├── layout
    │   │   ├── accounts_activity.xml
    │   │   ├── lunar_layout_console.xml
    │   │   ├── lunar_layout_console_log_entry.xml
    │   │   ├── lunar_layout_log_details_dialog.xml
    │   │   ├── lunar_layout_warning.xml
    │   │   ├── np_progressbar_layout.xml
    │   │   ├── np_webview_layout.xml
    │   │   ├── upsight_fragment_billboard.xml
    │   │   └── upsight_marketing_content_view.xml
    │   ├── raw
    │   │   ├── configurator_config.json
    │   │   ├── dispatcher_config.json
    │   │   └── uxm_schema.json
    │   └── xml
    │       └── nativeplugins_file_paths.xml
    └── resources.arsc
    ~~~

4.  apply our knowledge that [Java is very easy to decompile][0] to the `classes.dex` file
5.  realize that you don't want or need to have a `dex2jar` command line tool
6.  google whatever you googled to find `dex2jar`, but put "online" at the end
7.  [Here it is!][0] Wow, so easy
    ![dex.png][]

8.  Spicy Boy! Look what we have here!

    ~~~
    .
    ├── android
    │   └── support
    │       ├── annotation
    │       │   ├── AnimRes.java
    │       │   ├── AnimatorRes.java
    │       │   ├── AnyRes.java
    │       │   ├── ArrayRes.java
    │       │   ├── AttrRes.java
    .
    .
    .
    ~~~

9.  Ok, so there's a lot of nonsense here.
10. Let's `grep` for things like `pokemon`:

    ~~~
    .
    .
    .
    │   │   ├── nianticproject
    │   │   └── holoholo
    │   │       └── sfida
    │   │           ├── BuildConfig.java
    │   │           ├── C0779R.java
    │   │           ├── Manifest.java
    │   │           ├── SfidaFinderFragment.java
    │   │           ├── SfidaMessage.java
    │   │           ├── SfidaNotification.java
    │   │           ├── SfidaUtils.java
    │   │           ├── constants
    │   │           │   ├── BluetoothGattSupport.java
    │   │           │   └── SfidaConstants.java
    │   │           ├── service
    │   │           │   ├── Certificator.java
    │   │           │   ├── SfidaButtonDetector.java
    │   │           │   ├── SfidaGattCallback.java
    │   │           │   ├── SfidaService.java
    │   │           │   └── SfidaWatchDog.java
    │   │           ├── tatsuo
    │   │           │   ├── SfidaController.java
    │   │           │   ├── SfidaDevice.java
    │   │           │   └── SfidaUUID.java
    │   │           └── unity
    │   │               ├── EncounterPokemonClickCallback.java
    │   │               ├── PokestopClickCallback.java
    │   │               ├── SfidaUnityPlugin.java
    │   │               └── UnityInterface.java
    ~~~

11. Wow! You ain't never seen so many Juicy Secrets®!
    But who knows, this could just be a bunch of trash.

12. Hire an unscrupulous Java programmer to sift through the codebase


### Results & Discussion ###
So, in about an hour, I got my mitts on the cross-compiled Pokemon Go source code.
I didn't expect to be able to get all the way back to a working Unity project,
but I also didn't expect to get nearly as far as I did.
I could imagine someone reconstructing the object model of at least the mobile app from this.


### Conclusions ###
The reason I'm not in the news right now is that this is only part of Pokemon Go.
While we basically have the app's implementation, the serverside code isn't accessible.
You can [try][2] poking around in the server, but all you'll get is a cute message:

![server.png][]

Even though this isn't the full picture,
I have little doubt that the first clones of Pokemon Go have already been hacked together.


[0]: <http://www.javadecompilers.com/apk>
[1]: <http://www.apkmirror.com/apk/niantic-inc/pokemon-go/pokemon-go-0-29-3-release/pokemon-go-0-29-3-android-apk-download/>
[2]: <https://pgorelease.nianticlabs.com/plfe/>

[server.png]: </rsc/pokemon/server.png>
[download.png]: </rsc/pokemon/download.png>
[dex.png]: </rsc/pokemon/dex.png>

