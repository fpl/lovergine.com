title: Refurbish to fight against planned obsolescence
date: 2024-09-25 18:30
tags: society, technology, obsolescence
summary: Some notes about using refurbished equipment.
---

The planned obsolescence of computers and other IT electronic equipment is a
well-known plague of our age. For years, I stopped buying new computers and
prefer refurbished ones whenever possible. That includes all my personal ICT
boxes, and even at work, I try to spin out the life cycle of the equipment in
use under my direct management.  Proprietary OSes often limit the lifespan of IT
equipment, but in some cases, vendor-independent FOSS software can replace the
original one at End of Life (EOL). This is beneficial because FOSS software is
often more lightweight, customizable, and has a longer support life, thereby
extending the usability of your equipment.

For instance, I'm writing these notes on a dual-processor Lenovo Thinkstation
C30 refurbished workstation that left the factory 10 years ago with plenty of
RAM I bought 4 years ago. Thanks to the use of SSD storage instead of the old
HDDs, I hope to use it for at least another 4-5 years. My living room Thinkpad
L540 refurbished laptop is the same age, again with a replaced SSD, and I bought
it in the same period.  My main office personal HPZ320 workstation has been
around for almost the same number of years, while my office laptop is a damn new
Thinkpad X1 Carbon 5th-Gen of 2017. Both of them were new at buying time.

Of course, all of them run Debian GNU/Linux and have been upgraded regularly
during the years. This is essential. Otherwise, the well-known proprietary OSes
will obsolete your boxes, and you will be screwed.  Generally, this is an easy
task because reasonably aged computers are better supported by FOSS kernels. It
would be better to avoid well-known vendors with problematic or unsupported
devices.

I have even run a couple of aged Seagate Personal NASes in EOL for years, thanks
to installing a plain Debian for ARMv7 processors distribution instead of the
original Seagate one. I think they have been around for almost ten years, and
one is a used unit. Of course, HDDs changed in the meantime.

Some servers still in use are the rock-solid IBM xSeries.They were born with a
Suse Linux ES 11 and are still around and doing their jobs under Debian. Of
course, the trade-off between power consumption, budget, and goals must be
rigorously considered.

## Plan for the future in advance

In order to run computers for a long time, I found it essential to buy with more
RAM than needed at the moment of buying (even in the case of new boxes). You
will need more, and assume you still don't know. Possibly, the same is true for
the number of cores. If you buy a refurbished computer, it is inevitably a
professional/business unit you would never find in a shop for home users. That's
better because they generally have superior quality and decent support in the
Linux kernel.  In the business market, note that many companies retain computers
for an extended guaranteed time only (by internal policy), so you will always
find 3-5 years-old equipment recycled by medium/big companies. For personal use,
they are more than enough and exceptionally usable with a FOSS OS.

Even note that current computers (but for GPUs) are comparable to reasonably old
computers (let's say the last 10-12 years) in terms of the number of cores,
speed of RAM, and bus throughput. They are faster, but not so much. Their
average power consumption should be lower, but Moore's law is dead, sorry. So,
buying new computers is quite pointless in most cases, and even worse if you
purchase a consumer low-end computer for a limited budget. A refurbished box is
generally the best option because it is cleaned, incorporates ad hoc changes
(e.g., a new SSD for old units), is tested, and includes a one-year warranty by
its vendor (generally, but just check before buying). Even the refurbished
computer was at least an SOHO one, not a home product, so it is a much better
option.

## Be redundant, be safe

I never base my daily activities on a single box. At home and at work, I always
have forklifts and replacements for emergencies. You cannot trust old (or even
new) units, and not for sure in the long term. The same goes for parts such as
HDDs or SSDs. _Ça va sans dire_ that you need to take care of your data and
backup with required redundancy, too.

## Missions impossible

As said, the refurbishing possibility is minimal for GPUs and in some application
domains. I'm not a gamer, but there are rumors about forced obsolescence every
few years for commercial reasons triggered by games and vendors. Even for
high-performance computing, any GPU before late 2014 is not more truly
[supported or usable](https://en.wikipedia.org/wiki/CUDA#GPUs_supported). Again,
it is partially a matter of hardware, but proprietary software, including SDKs,
renders old GPUs obsolete.

Nowadays, the 2016 generations of GPUs with 8GB of VRAM are basically to be
retired for many applications: that was the standard size at the time, but now
vendors have decided that 8GBs or less is too few for any practical use. Too
bad.

Smartphones are another area where planned obsolescence is the rule. The most
expensive ones have 7 years of software support, but most can only be upgraded
to a pair of major versions. Basically, you should change your phone every 3-5
years because security support is limited in time. But the average replacement
cycle seems less than 3 years, anyway. Often, an older phone can still be used,
but it is at risk for security support. Too bad, again.

The same happens for many so-called smart electronic equipment: having a box
permanently connected to the network and missing any security support is
generally a bad idea, and only a small minority of them can be upgraded to FOSS
firmware. Cameras, TVs, routers, access points, and many other objects in our
homes have a sort of implicit counter for end-of-life that often stops before
the end of the hardware parts. You need to be very selective in equipment
vendors.

In many cases - guess what? - such devices now run an embedded version of
GNU/Linux that could be community-supported after the end of vendor support if
the vendor provided enough information appropriately, which is rarely a
possibility. In most cases, the vendor only has a public archive of third-party
FOSS source packages, not the entire build system, so community support is not
practically viable. Even any development documentation is usually totally
missing, just to discourage people from following that path. In many cases, the
devices include totally proprietary chipsets and drivers, so there is no way.
That's even the reason why Android is an almost-open mobile operating system.
Too bad, take three.

## Will it change in the future?

In general, this battle was lost years ago. Expanding or repairing a laptop
could now be challenging due to the accurate practices of many vendors to
discourage self-intervention. That's true for a lot of other equipment, too.
They are always ready to obsolete your products more often than you are
prepared. I'm a pessimist about the future of this war.

_They're coming outta the goddamn walls_

