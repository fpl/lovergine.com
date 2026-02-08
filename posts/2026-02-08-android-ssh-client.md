title: A decent SSH client for Android is not what one would expect
date: 2026-02-08 16:00
tags: android, configurations, computing, rant
summary: Anroid, ssh and bad clients.
---

I’m not too happy with using mobile devices as a daily driver for server
connections. When one needs to use a keyboard, in many cases the appropriate
device is inevitably a laptop or a desktop computer. Anyway, sometimes it
happens  that the mobile phone should be used as an SSH client for an emergency
or to perform simple remote tasks. Possibly something that is usable, decently
supported, and can share common configurations among multiple devices with a
reasonable level of security.

For years, the most used client on Android has been *JuiceSSH*, but unfortunately,
it became abandonware some years ago, and at the end of last year, it was also
delisted from the PlayStore. A few days ago, I changed my smartphone and
finally moved to the latest [Fairphone](https://shop.fairphone.com/home) model. 
Now, who knows me already knows how
much I hate mobile phones, which are generally the realm of apps with the worst
UX ever conceived. Since then, I discovered that the pro option of JuiceSSH is
also dead, and basically, SSH forwarding cannot be used anymore. Too bad, I
decided to look for a state-of-the-art SSH client application and discovered
that the generally suggested apps (i.e., Termius and Connectbot) are the usual
PITA.

Thanks gosh, *Termux* entered the room. 

For people who don't know it, it is an Android terminal that emulates a color
xterm, but has some nice features, specifically a damn good 
[package management tool](https://wiki.termux.com/wiki/Package_Management)
built in. Of course, it is pure FOSS, too.
```
pkg install openssh git vim
```
Now it could be nice to access the common storage area by enabling it with
```
termux-setup-storage
```
This could be useful for exchanging files with remote hosts and keeping them
available for/from other apps.

Now, a useful `.ssh/config` file can be pulled via `git`, stored locally, and
possibly customized to simplify ssh network access, with all helpful host
stanzas. Even a local password-protected host key can be created and stored
locally for safety.

So far, so good. Probably, I should simply start giving up on treating Android
as a special beast and treat it as just another Linux host. Fewer apps, more
terminal, and fuck the majority!


