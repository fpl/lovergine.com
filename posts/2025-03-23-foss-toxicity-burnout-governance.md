title: FOSS toxicity, burnout and governance (again)
date: 2025-03-23 15:40
tags: development, foss, governance
summary: About toxicy in FOSS projects and missing rules for governance
---

I recently read with interest [the post where Hector Martin resigned as Asahi
Linux leader](https://marcan.st/2025/02/resigning-as-asahi-linux-project-lead/).
As possibly well-known, Asahi Linux is the very first Fedora-based distribution
where all the hard work to support the Apple ARM M* chip series in the Linux
world found its way.

Dismissing the whole thing as another episode of burning out for a FOSS
developer would be ungenerous. Some elements are typical in such cases, such as
the excessive users pressure on the project. That caused a lot of pain and
over-reactions in other contexts, but a big part of the Hector experience is
related to issues with the upstream Linux kernel within the more general
Rust-in-Linux saga.

Of course, harsh behaviours and bad relations with other people are common
patterns in all human activities and often require a very thick skin and big
diplomatic capabilities to get positive results. This is not specifically true
for FOSS developers only (even if I say that a lot of developers are quite
peculiar on the side of human relations, often in a semi-pathological way).

In my life, I have had the opportunity to deal with another very peculiar human
category, such as cavers. Even when no money is involved, human beings can
create bad relations, internal wars, and unhealthy atmospheres for their
fellows. So, I guess it is a standard part of all human-to-human interactions,
not a FOSS ecosystem peculiarity. A lot of people are strongly opinionated, and
when also passionate, they tend to become intractable.

That said, I will concentrate on a specific part of Hector's post.

```
[...]
Back in 2011, Con Kolivas left the Linux kernel community. An anaesthetist by
day, he was arguably the last great Linux kernel hobbyist hacker. In the years
since it seems things have, if anything, only gotten worse. Today, it is
practically impossible to survive being a significant Linux maintainer or
cross-subsystem contributor if you’re not employed to do it by a corporation.
Linux started out as a hobbyist project, but it has well and truly lost its
hobbyist roots.
[...]
```

This is indisputable, IMHO, and it is likely the root of many problems that
afflict the Linux kernel community and others. When people start working
side-by-side with others who are motivated and sustained by different goals, it
could be the seed of big social issues. Linux is not more _just for fun_ for
years, and that can create friction among developers. That includes perception
about what should be considered acceptable for project sustainability and what
should not.

These days, all that includes the use of profiling features for projects that
are directly exposed to end-users and definitively the acquisition of personal
habits and/or information about the users. This is not the case of Linux kernel,
but it is a concrete issue for organizations such as the Mozilla Foundation and
its products, and could become a divisive issue for OS distribution projects, as
already happened in the immediate past.

Another problem is the wrong perception that a FOSS project should always accept
contributions and enhancement proposals, while often it is not due or obvious.
Like it or not, no acceptance of contribution is due, and I would add that FOSS
projects could (or should) be very conservative in those regards, i.e. answering
thanks-but-no-thanks more often than I have seen in recent years. IMHO, this
gives evidence to what, for me, is an urgency for too many projects to list
here, including, in practice, all programming languages out there.

Adding features over features on a piece of software is almost never a good
policy because it increases the entropy of any software product and decreases
its usability. The original spirit and goals of the software that possibly
decreed its success should always be preserved, and that has been the basis of
the original success of the Unix operating system approach, as an ensemble of
compact and independent tools that solve single problems in the most general,
simple and elegant ways, tools which are able to glue together to solve complex
tasks.
Now, this simple vision is already a source of friction among developers because
maintainers are so often obliged to answer negatively to pull requests and
patches for either respecting quality levels or opportunity.

This is a delicate trade-off that should be translated for every minimally
articulated project in a written Social Contract to state and explain the goals
and rules to respect for both users and developers. In a word, the governance
_principia_ of the project need to be defined _ex-ante_ and not _ex-post_, to
avoid misunderstandings and inner fights, as well as avoidable pressures during
time. Unfortunately, many FOSS projects tend to delay _ad libitum_ the
definition of an explicit Social Contract or introduce that - more often, only a
Code of Conduct for contributors is contemplated - when it is too late. Many big
projects do not even have such explicit statements, and it is a pity. Users and
developers should always be aware of such rules and goals in the life of any
FOSS project.

One of the biggest problem nowadays is having such governance clearly
established for life, but another is also ensuring that users and developers know its
existnce and respect it, the two side of the same problem

