title: Rebuild process running
date: 2024-07-04 19:00
tags: haunt, guile
summary: I started to write blogging notes with Haunt
---

A long time ago, in a galaxy far, far away... I used to have a personal home
page hosted somewhere. That was one of many other side projects of my life.  I
discovered some years ago that having multiple failed side projects along the
way is a common experience for geeks and for many non-geek people, too. For
reasons that are still not completely clear to me, some months ago, I decided
that restarting a personal website in 2024 could be a not so weird idea.

One of the motivations is probably connected to the general idea that abandoning
corporate social networks and regaining possession of our digital identities is
nowadays the way to go. The [indieweb](https://en.wikipedia.org/wiki/IndieWeb)
is a return to the original idea of the World Wide Web and a duty of all of us
geeks of the early days of the Internet.

For the same reason, the only social network I'm now actively using 
is [Mastodon](https://floss.social/@gisgeek).

That said, blogging could be a challenging activity for me, I rarely think my
casual thoughts are deep and interesting enough to be good for a public
exposure. I generally prefer to focalize on activities that require more
time and efforts than a few minutes to write down a draft note. But anyway,
let me start and see how it will go in the next months.

In the next few sections I'll dial with how I created this system and what
are my goals for the next short future.

## Jamstack

First of all, I decided almost immediately to run a [_jamstack system_]
(https://en.wikipedia.org/wiki/Jamstack) for
generating static pages starting from simple text documents. Such kind of
system is more than enough for my purpose and even for a lot of web sites 
out there that instead use [Wordpress](https://wordpress.org/) or other exotic [content management
systems](ihttps://en.wikipedia.org/wiki/Content_management_system) with a 
[DBMS](https://en.wikipedia.org/wiki/Database#Database_management_system).

## Lisp and Scheme

Once decided for a _jamstack_ the possible choices are embarrassingly 
numerous, but as a few people could know, I always prefer by age and inclination 
unconventional _niche_ solutions for my personal stuff. So, why not taking in 
consideration a family of languages that last year I decided to go in detail 
and never touched before? That would be the perfect occasion to motivate myself
into such study.

## Guile and Haunt

Fortunately, the possibile choices for a jamstack application is much more 
restricted, and I soon focalized on the *GNU Guile* dialect of Scheme
and the [Haunt blogging application](https://dthompson.us/projects/haunt.html) by 
[David Thompson](https://dthompson.us/). In just a couple of hours I managed to 
bootstrap all required modules and scripts to create a working system. Great!

## So what?

The following posts and work will probably be concentrated on refinements of the styling
and code, but at least I finalized an initial version of this new blog to write
about... what? Well, I'm a techie and researcher in Earth Observation and remote
sensing of the environment, with a special interest in geospatial technologies at large,
so some topics will be obvious. For all the rest, who knows? Have a look to my
haunt from time to time, it could be interesting...
