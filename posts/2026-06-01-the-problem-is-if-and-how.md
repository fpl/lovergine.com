title: The problem is not only if, but how.
date: 2026-06-01 13:30
mastodon: https://floss.social/@gisgeek/116675475096793216
tags: ai, society, internet, technology
summary: Problems with AI in FOSS is first if, then how adopting.
---

Ok, such dramas and the whole topic are starting to be annoying.
The [last episode](https://neuromatch.social/@jonny/116666900898570791) 
was the [rsync project](https://github.com/RsyncProject/rsync) 
with the well-respected Andrew Tridgell
as maintainer, who initiated a Claude-based development effort for the 3.4
series a few months ago. The rsync tool is a well-known, widely used tool for
copying files between hosts in a smart way, includes a daemon to optimize file
transfers, and serves as an entry point for synchronization.

Only at the end of May, when some regressions began to appear, this step by the
tool's main developer triggered the opening of a 
[rather harsh issue](https://github.com/RsyncProject/rsync/issues/934) regarding
the use of AI agents in development. One of the most consistent changes in the
source tree has been the introduction of Python helpers to replace the tool's
test coverage. This is not a new type of controversy; it appears as a quite
common pattern. AI tooling for programming (or automatic programming, as Antirez
calls it) based on specifications and natural language appears to be quite
widespread nowadays.

It is no novelty that such applications provoke a divisive reaction, with fans
and detractors of a tool that, at first glance, appears almost magical for
creating new programs from scratch in any language, or for reviewing existing
code, or for evolving any existing project through extended, progressive pull
requests. This is particularly annoying for many contributors when the AI agent
is blindly used as a committer or to create PRs or issues.  The whole
controversy comes into dramatic focus when the project is a prime-time one, as
in the case of rsync.

Note that rsync has been with evidence in quite low-intensity maintenance in
recent years, with several hundred issues open and almost 50 PRs proposed but
still pending. This is quite normal for seasoned FOSS projects, like it or not,
and specifically for low-voltage tools that have most of their life-cycle in the
past. Rsync is a  tiny utility based on less than 150,000 lines of C code,
started about 30 years ago by Tridge. In 2024, he stepped up again as a
maintainer, likely due to the project's overall status (merely not abandonware,
but almost such). This is, unfortunately, the known problem of too many FOSS
projects to count: they are old, seasoned programs developed years ago and
substantially frozen, but for minimal maintenance. They are often written in
legacy languages, such as pure C, which are quite far from the interests of
average Gen Z developers. Development teams are minimally set up, even under a
foundation umbrella, and interest in advancing them concretely is equally
minimal. They are what I call ‘good enough’ projects, often of widespread use.
They could be so legacy that they are considered carved in stone.

Of course, in 2026, the temptation to revitalize such legacy programs with AI
tooling is extremely high. It is higher when developers are overwhelmed with
many other tasks, and you know, maintaining such a project can be extremely
boring. But when the tool in question is considered a brick of the whole FOSS
basement and used as such by tons of reverse-dependent projects, the whole
operation can be extremely prone to controversy and intolerance. There are not
only problems of quality assurance for the final result, but also ethical and
philosophical questions about the use of AI tooling. All such aspects cannot be
ignored, and some kind of caution is required.

To introduce AI tooling into such a project, the first step is to reach an
agreement among all parties involved. That would lead to an accepted, explicitly
stated AI policy (which apparently lacked in the case of rsync). The most
accepted approach currently is a rigorous human-in-the-loop development policy
(as accepted in the Linux kernel, for instance). Without them, any forced use of
AI tooling for community-based FOSS projects is doomed to failure and
controversy, which could ultimately lead to a fork and the dispersion of effort
and energy. This consideration implies that the project has already adopted some
form of governance. Once the IF phase is passed, the HOW step must be
consequent. It is totally unacceptable that a human-in-the-loop becomes a purely
formal step before committing. In other words, the project committers need to
strictly review and commit to avoid regressions and subtle bugs, which could
easily be present with or without the AI contribution, but for sure are a risk
when one touches legacy code. The human committer is responsible. Being
proactive is a duty and cannot be neglected. Better to do nothing than mess up
working code. I don’t know if this has been the Tridge’s case, but regressions
have happened, which isn’t a good signal, and the whole thing could lead to
unexpected upset.

But, but, but... Wasn't the AI tool the magic silver bullet to solve all software
issues and productivity?  Well, dudes, I’m afraid that you need to change your
mind. There’s [no silver bullet](/still-no-silver-bullet.html), even 30 years later. 
There’s no magic recipe to solve all problems with undersized projects, and someone 
has to pay the debt.

We still need engineers who do their job, damn it.

