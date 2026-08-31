title: Using AI tools with proficiency in the right context: an example.
date: 2026-08-31 15:30
mastodon; https://floss.social/@gisgeek/117190721144890643
tags: technology, ai, aiad, development, obsolescence, programming
summary: An example of AI applicatio in the right context.
---

The use of AI tools for development (AI-aided development, AIAD) and
intellectual work is a disputed, hot topic. I’m generally on the pragmatic side
in that regard. While the environmental impact of AI systems is evident and a
reasonable concern, these tools, when used with a grain of salt and a
responsible approach, can solve problems that would otherwise be hard to manage.
Keep man in the loop, to say it in one sentence, and do not pretend that such
tools can fully replace human judgment and capabilities.

This is the chronicle of a little project that quietly waited 12 years before
finding a solution, during a week of vacation. My caving group maintained a
website since the end of the 90s. As is typical for a non-profit association,
volunteers do all the work, and building and maintaining a website is not
usually a top concern for the average speleologist. At the very beginning, a
single member handled all design and content management. She was not a
developer, and in those years many of the websites were amateur products with
very few concessions to standards and consistency. Think of most of the
[Geocities](https://en.wikipedia.org/wiki/GeoCities) amateur sites, and you've got the idea.
That website was not different in those regards: dozens of little icons, navigation buttons, and naive layouts
on every sort of page. The good, old, and ugly web content of the past.

The old site was maintained until the beginning of 2014 and contained almost a
thousand pages on multiple topics and variously interlinked, all written by hand
under Dreamweaver with many tables to align stuff and very little CSS. That was
the time of Web 1.0 (or maybe 0.5). That year, I tried what I saw as a big
change for the future: moving to the most-used CMS of the time, WordPress. The
goal was to involve other members in a collective editorial effort, facilitated
by a system that simplified content creation. Unfortunately, after a few pages
were migrated by hand from the old site to the new CMS and a few new pieces of
content were added, the whole operation continued until this summer with very
little success, mostly stalled. The greater part of the old site remained as it
was, and the editorial team did not gain members. The main reason is that cavers
like caving, and a lot less they love writing anything, including the shopping
list...

At the end, we had a totally dead old site and a new one in turn to languish on
the same server. The WordPress site also added a concrete problem: the need to
migrate from time to time to new versions of the CMS, with a moderate-to-medium
load of effort for this purpose, and the prospect of having, in a few years,
just another abandonware to manage without prospects: a set of old static pages
can always be read in a browser, but a dead CMS is a completely different beast.

In that week of vacation, I finally managed to migrate all the content into a
Hugo-based _jamstack_ site, for both the WordPress and the historical old site,
including all past pages, converted into a uniform acceptable form for the new
site. That was only possible thanks to AI, through successive approximations,
with some auxiliary Python scripts and a series of trials, adjustments, and
views to check the results. Converting a bunch of one thousand old-fashioned
HTML pages is grunt work, so the miracle of completing a migration never done in
the past 12 years finally happened, only thanks to the help of the artificial
collaborator.

The final result is visible [here](https://gruppopugliagrotte.it), and a brief
chronicle of the multiple steps followed and choices made is 
[also available](https://github.com/fpl/hugo-gpg/blob/main/HOW_I_DID_IT.md). 
Both are in Italian only, sorry.

A major result is that AI tooling can be proficiently used in well-delimited
contexts and with careful supervision. When results can be easily checked and
verified, it is even better, and often an under-frontier model is more than
sufficient: I completed all tasks using mostly the Claude Sonnet model, not even
Opus. I don't own the required hardware, but I’m more than sure a reasonable
open-weights local model would have been more than enough for such a website
migration project.

So, do you have a grunt task you hate to do that no one will help with
because it's totally annoying, a waste of time, and requires no creativity?
That’s the perfect job for your preferred AI tool. Good choice and well done.


