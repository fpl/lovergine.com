title: Why now FOSS is different: AI and source accessibility 
date: 2026-10-16 14:30
tags: foss, society, development, personal computing, programming, ai
summary: FOSS is now truly free and open for all
---

Many FOSS developers and teams are vocal and critical of AI tooling used in software
development and maintenance today. They have some good reasons for that.
Development by specification can create a mess of code that nobody can truly
read and understand after a while, and the entropy can only increase over time.
One can try to restore order by working in a strongly ordered manner, making
only small improvements to the existing codebase, all under human control; also,
introducing a full-coverage testing codebase can help ensure we don't mess up
the existing codebase with every new change. Being extremely analytical and
imposing strict rules for code creation/change can also help, etc.

There are tons of pragmatic interventions in such a new way of creating software
that can reduce the inevitable mess we find when an information system is
described in natural language. But it is unavoidable that there is a good
quantity of uncertainty in the whole process. That’s part of the thing, and
often the LLM-based creation drifts off-track.

Another big concern is the copyright for the resulting code and the uncertainty
about possible copyright enforcement during the training phase for LLMs. About
that, I see very few possibilities for changes in the future, but for explicitly
adopting special licenses that exclude a priori such practices on existing code
bases: a theoretical possibility that, honestly, I see has very little concrete
possibility of being respected, due to the  massive bot traffic that the current
Internet shows. Another big concern is how the next generation of developers
will grow in this new world, with the prospect of having much less skill in
writing code in any language.

The resulting concerns are nowadays translated into strict or less strict no-AI
policies in codes of conduct for assessed teams. This could be an ad interim
phase: we have very little certainty about the future of such policies. If the
resulting contribution rate should anneal, I see very little possibility of
maintaining them as such.

At the same time, it is quite evident that AI tools are indeed very commonly
used by average developers, even on the proprietary side. I read about that
everywhere and in any communication channel. Of course, it is a matter
of shades of grey, but it happens with varying intensity.

I already wrote a few posts about such topics, but I would now have a look at
the other side of the coin. It is undeniable that AI tooling has popularized
coding among non-programmers. This is often a purely shallow impression,
because, as said elsewhere, using natural language to describe, in a
non-ambiguous way, a complex information system is not something trivial. That
said, AI tooling has greatly reduced the barrier to diving into unknown code
written by others, so that FOSS software principles have found their full
completion. Nowadays, anyone can truly take whatever software, understand its
internals as summarized by AI, and change it for personal use. 
Maybe the resulting code will not be
clean and general enough for creating a PR, but it will work for your own
limited goals. Software as a _commodity_, I wrote elsewhere, or even software that
is _good enough_.

Lately, I created my own fork and special branch of an abandonware (the
[sentinelsat](https://github.com/fpl/sentinelsat) package) that some years ago 
was used to download Copernicus images,
when it ran on the old DHUS service.  That service and protocol are still used
by ASI (Agenzia Spaziale Italiana) to distribute SAOCOM satellite images for
Europe. So I discovered that the old package was still useful for us in that
context, but needed a hack to properly work. I did that in a few minutes via AI.
No need to open an issue, create a PR, or anything else. Just software reuse and
problem-solving. That change has no purpose but to fix an inconsistency in the
ASI service. I did the same again today because of some changes on the ASI side.

Translate this small example to any of the many software systems that do almost
the right thing but would need a fix, an extension, a change, or a new workflow.
Just for you, your team, or a special application. Simply, now you can do it
without spending days, weeks, or months on it. Isn’t that the full sense and
application of the 4 freedoms in FOSS? Such freedoms are for all users, not for
developers only, and now users can do that, plain and clean. That branch is
there, publicly available in my fork, maybe useful for others or even not. I
don’t care.

Maybe someone will be disappointed by such a novelty, but not the users, for
sure. FOSS has never been reserved for developers with medals and titles to
adapt it. Now it happens as never before, even if someone is 
not happy about that.


