title: Storage is a pain, or why self-hosting is not always either desirable, or easy.
date: 2026-08-29 15:30
mastodon: https://floss.social/@gisgeek/117178989893068293
tags: technology, self-hosting, computing, personal computing
summary: Federated services are the answer, but not for all.
---

Self-hosting is the modern mantra, often presented as the final solution to
dependence on big companies. Unfortunately, NASes are not a backup, and in most
situations you have to arrange a last-resort escape: a B-plan and possibly even
a C-plan. This is a collection of horror stories from my personal experience.
They all ended (mostly) happily, but usually at the cost of a
replacement/integration, and they show what can go wrong when you rely too much
on a NAS (or a NAS pool).

![NAS baby sitting](/images/nas-baby-sitting.png)

At work, we used Synology NASes intensively for years. The very first unit was
used as an iSCSI device until the XFS filesystem became locked in read-only mode
after a kernel upgrade, due to some odd intersection of stars in the sky
(including a kernel-level problem), with no way to run fsck to fix it. The final
solution was to buy a new NAS and copy the data, with some weeks of work
freezing. 

In a few years, the NAS cluster grew, until one expansion started having subtle
hardware problems, with sudden, temporary eSATA link timeouts and degradation of
the RAID arrays. Again, a unit replacement was due, but it triggered a grave
Btrfs consistency corruption (thanks, Synology kernel fork! I love you, damn it)
on a data volume first, because shit happens. 

Synology NASes are very affordable and reliable units, until they are not. 

And when they fail, the failure is generally catastrophic, with no possibility
of recovery and corruption of RAID volumes. It doesn't help that they don't have
a console mode, either. In the meantime, we also had to replace a series of HDDs
(maybe 20% of them) and maintain spare disks in case of failures. 

All that has a concrete impact on ownership costs. Even if we use
5-year-warranted disks (enterprise grade), we inevitably have a large portion of
them out of warranty. A large portion of almost a hundred HDDs of various sizes:
guess the whole cost of that thing.

The proprietary OS and absence of a console are the main reasons why we changed
NAS brands (we now moved to Terramaster with plain Debian): the ability to
control and look at the low level before trying any recovery is priceless.
Disclaimer: we rarely used all the bells and whistles from DSM OS because our
storage use is much more aggressive than average, with big files and intensive
I/O. The application level is not our primary interest, so in recent years we've
simply used a Docker container to run a GlusterFS daemon on the Synology NASes.
Also, DSM limitations shaped some technical choices: too many small RAID pools
instead of larger ones, and using Btrfs instead of the more mature XFS. And we
paid the price, of course: less space, less performance, and finally also less
stability.

In the last, maybe 10 years, we adopted GlusterFS as our main carrier to manage
pools of NASes. Starting with a low-bandwidth 1Gb network, we had to move
towards 10Gb when the number of units increased.  We had to learn to manage
GlusterFS oddities and problems, which is not a specificity of such a
distributed system: all distributed filesystems are weird beasts. I experienced
multiple HPC clusters worldwide, and all implementations, like it or not, have
issues from time to time, as well as multiple limits one has to consider to
avoid problems. The crude reality is that all of them need some form of
continuous babysitting, which again impacts the cost of ownership. We had a last
event this summer, which stopped us for some weeks.

So the lesson learned is that self-hosting storage has hidden costs and risks:
when one has to follow such a siren, (s)he needs to be conscious of all
implications, and when possible, a well-managed cloud solution (e.g., using
independent encryption for privacy) could be the best alternative. 

Because self-hosting storage is only an apparent saving, you could pay the full
price later, and that’s often neither evident nor quantifiable.

