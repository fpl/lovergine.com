title: About computing environments for reproducible science
date: 2025-12-09 13:00
mastodon: https://floss.social/@gisgeek/115690004441124170
tags: guix, development, computing, distributions
summary: Reproducible science, problems and possible solutions via Guix.
---

A few weeks ago I gave a lecture for the [Spatial Ecology
course](https://spatial-ecology.net/course-geocomputation-machine-learning-for-environmental-applications-intermediate-level-2025/)
to introduce a handful of junior and not-so-junior researchers from various
domains to the not-so-nice world of scientific computing environments.

![Poor Galileo working on modern computer](/images/galileo.png)

For people interested,
[here](https://spatial-ecology.net/docs/source/lectures/lect_20252511_dependency_management_in_data_science.pdf)
are my slides about this topic. They are somehow specialized for the Python
ecosystem (which has become nowadays the programming language adopted for
scientific computing in multiple contexts), where, in the last few years, a lot
of evolutions have taken place for the management of dependencies and the
management of the computing environment. This problem is amplified in the HPC
context (I already wrote [a semi-serious post](/does-hpc-mean-high-pain-computing.html) about such an argument).

I also cited [_guix_](https://guix.gnu.org/) without more details (it was impossible to deal with all
sub-topics in the lecture, and I know that multiple listeners already had
problems fully understanding the matter).

Reasoning about that, it is not a silly idea to write some blog notes about the
whole topic. First of all, what is the context? [Reproducible science](https://pmc.ncbi.nlm.nih.gov/articles/PMC2981311/)
is not a novel matter. Any scientific experiment should be reproducible, starting from the same
data and giving comparable results: this is the basis of the [scientific method](https://en.wikipedia.org/wiki/Scientific_method)
(Galileo docet). In the
context of scientific computing, that implies that the whole execution
environment should be fully reproducible in order to ensure the possibility of
replication of the executions, with the same outputs starting from the same
inputs. Possibly later on, running on the same platform, or after deployment 
on a new, completely different system.

The key point is that the long-term reproducibility of such results on current
platforms and with current languages is minimal, to be generous.  Having the
full source code of a Python notebook, a git source repository, or anything
comparable is simply only the starting point. The sad reality is that in
practice, the source code has, in too many cases, a lifetime of a few months
because of the understimation of such a problem by the average scholar. When
following a few good practices, such a lifetime can be extended to a few years,
maybe.

When I wrote my thesis, too many years ago, I developed the whole C source for
execution on a parallel computer of the time. It was a [Meiko Computing Surface](https://en.wikipedia.org/wiki/Meiko_Scientific), 
a SIMD platform based on [INMOS Transputers](https://en.wikipedia.org/wiki/Transputer). The C code
used a proprietary message-passing library, CSTools, to enable communication
among T-800 processors (unfortunately, there is no relation with the Terminator
series, sorry). Now, it is somewhat expected that a code based on a dead
proprietary library running on a dead hardware platform could have
reproducibility issues today, after more than 30 years.

What is unexpected is that one could have the same reproducibility problems
after 30 months, or in some limited cases, after 30 days. I mean both at the
binary and source levels, often. Now, part of the problem is due to the [FAFO](https://www.merriam-webster.com/slang/fafo)
attitude of some development communities. Not all teams are like the GDAL
one, which is capable of maintaining the same well-refined APIs for dozens of
years. More usually, from time to time, new versions of libraries and tools
introduce expected or unexpected breakages against past versions and APIs, which
backfire on programs that use them. In other cases, new versions can fix and/or
introduce bugs of primary interest for dependent software. Those are the main
reasons to meticulously annotate and document every single version of direct and
indirect dependencies. This is somewhat solved by dependency resolvers, as
explained in my lecture. But that's only part of the whole chain.

Unfortunately, nowadays this chain of dependencies traverses a single language
and crashes against system-level dependencies, including the whole operating
system, with its system compilers, interpreters, and libraries. This problem is
amplified in a fully containerized world, which is nowadays used intensively.
Depending on a third-party-provided binary image taken from any hub out there is
not a safer approach. Such images can disappear from night to day or have a
limited lifetime, so the conscious scholar should also develop his/her own from
scratch, which often is particularly out of the skill perimeter of the average
scholar.

This is exactly where Guix tries to give an answer. Guix is a source-level
package manager with a set of full descriptions written in Guile Scheme for the
whole chain of dependencies up to the kernel level. Combining such an analytical
description of the system for any built artifact in the timeline from the
starting point (derivations), along with the possibility to use build systems to
cache binary artifacts (substitutes), and install any software at the user
level, does allow the creation of a source-level definition of a full execution
environment.

Such an ambitious goal is not without problems, as magistrally summarized by
Ludovic Courtès
[here](https://hpc.guix.info/blog/2024/03/adventures-on-the-quest-for-long-term-reproducible-deployment/),
but anyway it is at light-years of distance from the possibility of the average
deployment system that needs instead continuous babysitting in order to ensure a
working environment.

What is probably of interest for general consumption would also be a consistent additional
security tagging for derivations in order to fast identify sources with known
CVE-tagged versions in the chain of dependencies. That would increase the level
of self-awareness when the Guix time machine is used to go back in the past and
pick some sources from Pandora's box. It would also be of considerable interest
in the [SBOM](https://en.wikipedia.org/wiki/Software_supply_chain) context
outside the perimeter of science computing.

So, guix is not perfect, but again a sure advancement towards reproducible computing 
environments, which currently lack in a way or another in the science domain
(and not only that).

## References

[1] [A guide to reproducible research papers](https://hpc.guix.info/blog/2023/06/a-guide-to-reproducible-research-papers/)

[2] [Guix as a tool for reproducible science](https://zenodo.org/records/7088068)

[3] [Using Guix for managing reproducible, flexible, and collaborative environments in a PhD thesis](https://inria.hal.science/hal-04776900/)

[4] [Reproducible genomics analysis pipelines with GNU Guix](https://doi.org/10.1101/29865o3)

[5] [Replication crisis](https://en.wikipedia.org/wiki/Replication_crisis)


