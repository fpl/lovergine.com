title: New frontiers of the FOSS contributions.
date: 2026-10-05 12:30
mastodon: https://floss.social/@gisgeek/117387976864689750
tags: technology, foss, society, development, personal computing, programming, ai, aiad
summary: Changes in FOSS software production and vision.
---

I recently sent [a brief answer to @krille](https://floss.social/@gisgeek/117364201238888128) 
on Mastodon about what managing an average FOSS project looks like in 2026. Christian is the main
author of a Flutter app (FluffyChat, a Matrix client). Indeed, this deserves a
more extensive discussion.

![FOSS sweeties](/images/foss-sweeties.png)

Currently, there are two kinds of FOSS projects out there: those that do not
have an AI policy and those that do. Among those with an AI policy, some do not
accept AIAD contributions. In contrast, others accept them under restrictive
rules, generally treating _man-in-the-loop_ as a distinctive characteristic for
accepting patches. In all cases, projects are currently seriously impacted by
indiscriminate submissions of AI-tool-based issues/PRs, with or without respect
for the project's policy (if it exists). Curiously, this is especially true for
security-related segnalations, which, for some reason, third parties also submit
regardless of the project's AI policy.

My thesis is that, in any case, PRs and issues with patch submissions should be
deeply reconsidered over the average project lifetime, on both sides of the
process -- i.e., the maintainer(s) and the contributor(s).

Firstly, if the project does not have an explicit AI policy, the maintainer(s)
should reconsider it: this is not the case for Christian’s project, which
prohibits AI tooling for both code and documentation (but it should also
possibly cover bug submissions, including security-related ones). Nowadays, an
explicit policy is mandatory; without it, you risk receiving any kind of
contribution (documentation, bug reports, and code) with or without AI use. In
practice, many AIADs contributions can be extra-verbose and off-topic, or pure
garbage if created without a grain of salt (the so-called slop): the world out
there is full of weird individuals. Closing security-related AI-generated
reports could seem weird, but I honestly don't see any reason not to, especially
when such reports are one-shot, with no decent follow-up or clear use
cases/exploits.

I’m often on the AI-tooling with human-in-the-loop side, but I fully respect
people who think differently. On my side, I simply avoid sending any AI-tooled
contribution when an anti-AI policy is explicit. On my side, if I'm motivated
enough, I fork and create my own repositories for my own use, without pretending
to force other parties to follow me in my choices. In many respects, that’s also
more immediate and manageable for everyone involved (including me: preparing a
decent PR proposal takes effort). As I said in a past post, this will probably
be the future of most current FOSS projects, deeply changing the code-sharing
paradigm.

Indeed, I’m now more convinced of the value of the BSD license compared with the
GPL. The FOSS code for most projects out there is now simply a proof of concept
to adopt and adapt for your own use, with whatever changes you find necessary
and sufficient for your goals, whatever they are. A totally source-level pure
commodity to use as a brick in your workflows. With AI tools, the initial
barrier to diving into an existing codebase and managing changes to whatever
code is extremely low, if not pretending to create the best code at any cost. As
such, most of the FOSS code will be inherently low-value/low-interest, what
generally could be considered pure personal projects.

The results could be good enough for your own use without pretending to be
general or refined. And, like it or not, this could be more than enough for your
on-purpose/limited use. Nowadays, I create a lot of write-once-use-and-forget
code to solve a specific task, and it is not even written in Perl (ok, I’m
joking). I generally publish those in one of my repositories, just to remember
them later and back them up. They may or may not be useful to others or even to
me later; I don’t worry about that. I don’t expect third-party contributions,
and it is totally intentional. Of course, a limited number of prime-time
consolidated FOSS projects with large teams and well-selected contributions will
also exist in the future, but that’s not the typical case for many of us, now.

At the same time, the inherent value of many categories of FOSS projects is now
truly lower than it was in the immediate past. For instance, I now have very
little interest in learning and using client-side frameworks or libraries that I
use rarely or could reimplement in plain JavaScript for what interests me. I
have also stopped using general-purpose CMS and server-side frameworks like
Django or Drupal. This is also true for most geospatial webGIS applications, for
which a Jamstack architecture with a simple Spatialite database is more than
enough for many uses. This approach can maximize the possibility of using AI
tools through fast change-and-review cycles. This is true in my case, but I
expect it to be true for many developers in multiple fields, and it will impact
many projects in the immediate future, resulting in fewer developers, fewer
users, and smaller communities per project. I expect many once-first-class
projects -- created to provide higher levels of abstraction to simplify
development -- to become legacy software sooner or later, with limited
maintenance. Who needs simplified layers of abstraction when AI can reduce
complexity on purpose?

At the same time, in the enterprise, AI tools have become the most common and
inevitable solution for software management. When people prioritize productivity
and results over quality and full understanding of code, this is unavoidable. As
I've said in other posts, the AIAD approach isn't black-and-white, but a matter
of shades of grey. Of course, the temptation to treat AI tools as a silver
bullet for any engineering problem is a real risk in the enterprise environment.
Still, AI is unavoidable, and it also impacts team composition and the daily
work of most developers, whether they like it or not. You can still decide how
to manage your own FOSS personal projects, but when your job depends on adopting
certain workflows, I see few options for escaping mainstream tendencies. And,
like it or not, AI tools are mainstream by now, and here to stay.  For sure, it
is totally pointless to be harsh with people who currently have different views
about using AI tooling in programming, and I don’t agree with the opposite
attitudes of commiseration between the two different schools of thought: there
are perfectly reasonable pros/cons on both sides.

We will discover the consequences (in any sense, for better or worse) of such
epochal changes in programming and knowledge management at large only in the
future.
