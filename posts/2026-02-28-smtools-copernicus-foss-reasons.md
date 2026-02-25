title: SM-Tools, Copernicus, FOSS and the reasons of inevitable choices and drifts
date: 2026-02-25 15:00
mastodon: https://floss.social/@gisgeek/116131649397542316
tags: foss, ai, copernicus, development, programming, science, computing 
summary: Copernicus, FOSS, AI coding and the reasons for choices
---

Here at work, we develop a series of tools for geospatial processing with
multiple goals, expected maintenance durations, different scopes, generalization
needs, and motivations. Note that about 10 years ago, here in Europe, a
completely new approach to upstream and downstream services for Earth
Observation began: ESA changed its data licenses, and distribution and access
modalities entered the Big Data era.

That even changed the data approach for academic institutions and triggered a
major shift in the daily work of researchers, with access to a tremendous volume
of weekly data available almost just in time and worldwide. Of course, such a
change also impacted us, and we had to adapt our processing and storage
capabilities to the new era.

One of my side projects in that regard is
[SM-Tools](https://baltig.cnr.it/francesco.lovergine/sm-tools), which consists
primarily of a collection of support tools for running our internally developed
soil moisture algorithm using SAR satellite data ([SMOSAR](https://sarwater.irea.cnr.it/smosar.html)). 
One such tool (now named `smt_copernicus`) began
(and evolved with multiple restarts-from-scratch) more than 10 years ago, when
the Sentinel constellation started operations. Its purpose is to search for and
download satellite products from Copernicus archives using multiple criteria,
and to maintain an internal geospatial database of these products, along with
all derived maps and ancillary data. This is only one component of a system that
should be able to process large quantities of multi-source data on selected
areas of interest, create downstream products, and calibrate and analyze results
by comparing them with field data. The clear final goal is to achieve new
findings in satellite data analysis, supported by extended processing worldwide,
and to introduce new algorithms.

This is a long-term goal that unfortunately runs up against short- to mid-term
difficulties of accessing archives that are not under our direct control. The
sad reality is that in the last 4 years,  the Copernicus archive access modality
changed 3 times, and in the previous period, Copernicus also changed policies
and modalities in progress (e.g., by introducing online and offline products,
changing formats, etc.). Geospatial communities are small enough to encounter
more practical difficulties than expected in such operational conditions, and
this is now an almost weekly experience. We now have to chase other parties’
changes more often than we did in the past, rather than working on our own goals
instead.

For instance, until 2023, the main package used for accessing the Copernicus
archive was the [Sentinelsat](https://github.com/sentinelsat/sentinelsat) 
Python package (developed by an handfull of willing
scholars starting in the summer of 2015). It became abandonware that year when
people discovered that the protocol changes required rewriting most of the
package from scratch, including all test code and mockings. That happened again
at the end of last year. Incredibly enough, all access protocols have been an
ongoing affair since 2023, even for non-secondary details, and required frequent
adjustments to avoid unexpected breakage in download and processing pipelines.
That for sure does not encourage community-supported FOSS solutions. Exactly in
2023, when I discovered our Sentinel-related tool had to be deeply changed
because of the lack of the obsoleted Sentinelsat package, I decided that enough
was enough and managed to migrate from Python to a fully self-supported Perl
reimplementation: one of the things I always hated in the Python ecosystem is
the excessive (for me and our purposes at least) speed in deprecation of
consolidated packages and features, and the prospective of having to chase after
unexpected changes in both Copernicus AND Python sides was out of question. My
experiences with Perl have been much less annoying in this regard, with scripts
running perfectly even after 20 years since they were written. Let’s consider
this the old-school approach: if something is working, don't touch it without a
more than valid reason, and even then, think twice before you touch.

In the meantime, around 2019, another independent effort started to support
Copernicus access, along with a few other data providers. That’s about  4 years
after the original Sentinelsat project. Timing in this case is essential to be
considered. [EODag](https://github.com/CS-SI/eodag) 
is a single-company FOSS product that has been actively
developed since then, but may have been considered stable 1-2 years later. Of
course, it only provides the usual access layer, and using that package implied,
at the time, replacing Sentinelsat with EODag as a base layer for searching and
downloading only, while performing other tasks afterward with other self-made
code. Before 2023, using Sentinelsat or EOdag was equivalent in order to perform
the same task, with very little advantages.

Note that both tools were, in any case, pretty adequate but not enough for our
goals, and also had a few defects (or a lack of flexibility, to say better) to
manage in some creative way. That has been one of the reasons for not replacing
Sentinelsat with EOdag in 2023. The other major one was that the idea of
replacing a small package with another (as for Sentinelsat, there are just a
couple of main contributors to the codebase, along with a good number of
pending issues and PRs for such a kind of product) is probably not the safest
one to avoid problems in the near future, when Copernicus will change things
(again, see the next Earth Observation Processing Framework EOPF data format —
Zarr). And of course, EODag is written in Python, and I already expressed my
concerns about that.

Even if you like it or not, nowadays, the concrete alternative to adopting small
FOSS projects to perform basic tasks is to use AI tooling to create a perfectly
(or almost so) tailored implementation for the target task. While in 2023 I had
to rewrite from scratch (in maybe a month of work with some fixes to
[Geo::GDAL::FFI package](https://metacpan.org/dist/Geo-GDAL-FFI) 
for a multi-threading issue) an implementation of a
multi-threaded tool for accessing the Copernicus archive and maintaining an
internal geospatial database of products consistently among multiple
generations of the archive, I implemented the STAC protocol variant in a few
hours instead, thanks to Claude Code-based patching and my reviewing and tests
for the resulting codebase. As said in [this
post](/is-ai-driven-coding-the-start-of-the-end-of-mainstream-foss), currently,
the cons of adopting a small third-party FOSS solution outweigh the pros,
particularly regarding the resulting technical debt, compared with a
well-conducted self-consistent AI-based development process.

I’m seeing in my own side projects exactly the mirror of what will probably be
the reality of FOSS projects in the near future, in practice, as I mentioned in
the previous post. Relatively few major/interesting projects will be adopted by
others and attract contributions, while most codebases will become pure one-man
shows, with AI tooling.

A significant part of geospatial processing involves data procurement and
processing, i.e., refining and preparing data and images in order to collect,
filter, and process large volumes of data for subsequent analysis. This is the
most annoying and repetitive part of the process, and also often the most
time-consuming. In my experience, working on those tasks is probably the most
effective way to use LLMs through a spec-and-test-driven design. Whether you
like it or not, it is the most immediate way to produce working code by
iterating with a chain of thoughts and accurate reviewing of results, including
a decent test coverage. As observed in [Antirez's
experience](https://antirez.com/news/159), the AI agent also had the nice
ability to retain my Perl style (which is not secondary, given that Perl has
many programming flavors and variants).

Maybe the final results will be an increase in quick-and-dirty codebases, but
for many scholars, it will be a major simplification of their lives. In most
domains of science, coding activities have been seen as an inevitable evil: they
are a tool, not the primary goal, and even before the advent of LLMs, most
scientific codebases were far from something to be proud of. The Copernicus
attitude to FAFO will also encourage such approaches. Simply because scholars
don't have time to waste chasing changes introduced by this or that data
provider or company when contracts change.

AI sloping attitude? No, simple survival instinct.


