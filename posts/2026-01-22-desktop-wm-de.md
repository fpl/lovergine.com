title: The perfect desktop is a matter of points of view, or not?
date: 2026-01-22 19:40
tags: rant, distributions, desktop, technology, joke
summary: About Omarchy, window managers and desktop environments for the next Year of Linux on Desktop
---

I recently learned about an opinionated flavor of the Arch distribution called
[Omarchy](https://omarchy.org/), which is basically a collection of desktop
packages built on top of a rolling Arch distribution. Nothing special, but for
the vocal original author of the scripting job at the base of such flavor, who
is, as it happens, for many old-school self-centered geeks out there, the quite
discussed DHH. I will not enter into the merits of the reasons for the dubious
fame of David "DHH" Heinemeier Hansson, which basically stem from some of his
past posts on X/Twitter and some of his questionable ideas. 

![The great fight between WMs and DEs](/images/wm-vs-de.png)

I’m not interested in that here. I’m more interested in some spontaneous
thoughts about the hype (well, at least among the very restricted niche group of
Linux desktop fans) around this desktop flavor. It is not something new; the
Hyprland UX is basically an [i3](https://i3wm.org/)-like 
[tiling window manager](https://en.wikipedia.org/wiki/Tiling_window_manager) with steroids,
based on the current non-Xorg incarnation of Wayland, with a few whistles and
bells.

I have been a long-time Linux desktop user since the 90s, and a tiling window
manager (specifically one of the suckless incarnations, [Awesome WM](https://awesomewm.org/)) has been my
main desktop for quite a few years. Some years ago, I abandoned such a paradigm
when I finally realized that a pure tiling window manager is a great idea until
it isn't. Basically, most of its _pros_ (one application per virtual desktop, easy
tiling on big displays, keyboard-driven navigation) can be easily replicated in
a capable desktop environment like any current Gnome version. This has the big
advantage of being ready for use right after installation and of being easily
and fully customizable via plugins. The _cons_ of a tiling WM are always present,
based on workflows, and there are generally no easy workarounds. The biggest is
the need to find tricks and third-party tools to solve use cases that are not
always trivial (or worse, that are trivial on a DE instead).

A DE has the indisputable advantage of including all batteries for widgets and
customization tools, whereas most (all) WMs require third-party tooling to
manage many disparate configuration snippets, such as Bluetooth, Wi-Fi, hot-plug devices,
auto-sensing of beamers, dynamic multi-display, fast binding of container apps, 
accessibility featues, and many others. Too often, also, such WMs require using a 
command-line tool or a workaround to perform tasks that are simply part of the common DE experience.

I also remember the pain of using the multiwindow GUI of GrassGis under Awesome,
which was at the time just another type of application under a floating window
manager, instead. When an application opens a new window for every new module
used, well, the UX could become a nightmare under a tiling WM, if you are not
using a 43-inch display. The same goes for virtualized desktops, too: when the
guest and host collide for keyboard use, continuous control switching can
rapidly lead to madness. That’s just a pair of examples to conclude that the
coolness of a desktop implementation is often a matter of perspective and
personal workflows, and I constantly found that a mandatory tiling WM paradigm
is simply less flexible in some practical cases.

To be honest, I find the Omarchy UX to be the typical incarnation of a canonical
WM-based interface for fresh Linux desktop users. Such users are divided into
two classes:

* The class of people who are searching for an exact replica of Windows/macOS
GUI. A no-hope group of people: if something has to look like Windows, have
exactly the same policies and the same applications and icons, even, well,
probably they should stay with Windows: simple and clean. They are the most
critical and vocal complaining users for whom the Linux-on-the-desktop era will
never come.

* The class of people who look for something radically different and discover
the keyboard-driven interfaces as something almost magical (without fully
realizing that such an experience can be replicated easily and mostly by using
environment shortcuts and some simple plugins). A trivial secret, I would say.
They are the most enthusiastic about this kind of desktop, but also regular
distro-hoppers (yes, it is an offense for me: distro-hopping is for gamers, not
for workers who need to complete primary tasks daily) from time to time; more often,
they will never admit they are simply playing around, and solving auto-inflicted problems
is part of their game.

Of course, the WM-based desktop paradigm still has its own use cases, 
which I group under a very few  limited cases:

* You are using a strictly roll-on distribution, such as Debian sid/unstable,
Arch, Guix, Gentoo, and many other in-development flavors of other mainstream
distributions, including Fedora and OpenSUSE. On such distributions, avoiding
desktop environments reduces the likelihood of encountering temporary problems
after daily upgrades, as some transient (in the order of days/weeks) breakages
can occur. But who is the user of such platforms today? Seriously, I think only
someone actively involved in development and testing should be interested in
such distributions. Today, most desktop apps are distributed as containerized
packages via one of the multiple available hubs for Flatpak, AppImage, Snap,
Docker/Podman. I can’t see the practical advantage of using an unstable
distribution on a daily basis. If you think differently, dude, you have a
problem, and it is not the distribution you are using, but it is what you see in
the mirror. If you are not a YouTuber who needs to produce videos to monetize,
well, you are probably simply using the wrong distribution pointlessly (and
creating your own problems from time to time, which are perfectly part of the
roll-on experience, by manual).

* You are using an old, low-resource box with limited RAM and cores. A platform
that cannot simply be used with the current desktop environments. I seriously
doubt it could also be used for general computing, indeed. Nowadays, even a web
browser is simply a hungry hog on such platforms. I mean, a dual-core box with 4 GB of
RAM that could be more than 15 years old. If this is your platform, well, a
window manager is perfectly legitimate, but it probably couldn't be used with
Hyprland either. But to do what? I mean, but for installing it and telling it to
friends...

* You are an old-style lazy geek, anchored to your own configurations, refined
over dozens of years, with very few reasons to change. That’s perfectly
legitimate, but most of those configurations could probably be out of date. I
know, you are still adjusting your Modelines in your Xorg configuration. Well,
dude, probably it’s time to come down the tree in the forest.

Of course, I also tried to install Omarchy on an old box of mine (an 11-year-old
Lenovo ThinkPad L540 with a dual-core i5 and 8GB RAM) that runs perfectly with
the current Debian 13 and Gnome 48. Sadly, it was not even booted to install:
just a dark screen. Good, but not too good, dudes.

And this leads me to the elephant-in-the-room argument for this post. Most users
need stability and, occasionally, up-to-date applications. The average users
need certainty that they can easily install an OS on most platforms and have a
stable UX for a decently long period (let’s say 2-5 years without any
reinstallation in between). The more users, the more stability. The simpler, the
more effective, too.  And that’s the real point most devs (or wannabe experts) 
have probably missed in the meantime.
The desktop is a mere tool; it should not require an expertise addiction.

It is not a matter of DE vs WM, but of homogeneity and generality versus good,
but not enough for all. If one has to rediscover the warm water to manage a
configurable tool that, in a DE, is a click-n-point away, it is a failure 
in general UX. Of course, even DEs are far from perfect, but too often, WM UX is 
far from even being basically complete.

For instance, I can easily manage my full clipboard history with inter-session
persistence thanks to a simple Gnome plugin (i.e., Clipboard Indicator). There is no
equivalent widget in most WMs, but they need to use a third-party tool to
provide something that is almost equivalent, but often incomplete. Well,
Houston, we have a problem! That’s just an example, but the general approach is
clear: if one has to constantly sacrifice immediate, good-enough implementations
to adopt half-finished tools or workarounds to solve basic GUI workflows, WMs
become not accelerators of productivity but defective implementations, and that
has been my constant experience in that regard with WMs. At some point, one has
to set priorities, and after years, my priority has become not to waste time
reinventing the wheel for desktop GUIs. Sorry, guys. There is more than one way
to implement a desktop interface, but many of them can simply become a pain
because they are not flexible enough or incomplete, resulting in continuous
adjustings and workarounds to have something decently working.

And yes, this is another damn opinionated post about 
the current *Year of Linux on Desktop*. Don't take it too seriously...

