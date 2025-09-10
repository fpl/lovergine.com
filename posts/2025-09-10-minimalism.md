title: A call to minimalistic programming
date: 2025-09-10 17:00
mastodon: https://floss.social/@gisgeek/115180588612442724
tags: development, programming, computing, technology, books
summary: About minimalism in development
---

Minimalism in development is a forgotten virtue of our time that should gain
more attention. A straightforward summary of some minimalism principles is
available [here](http://minifesto.org/). Briefly, the principles of minimalism
in Software Engineering can be summarized as follows, based on the manifesto for
minimalism.

1.	_Fight for Pareto's law_: look for the 20% of effort that will yield 80% of the results.
2.	_Prioritize_: minimalism isn't about not doing things but about focusing first on the important.
3.	_The perfect is the enemy of the good_: first do it, then do it right, then do it better.
4.	_Kill the baby_: don't be afraid of starting all over again. Fail soon, learn fast.
5.	_Add value_: continuously consider how you can support your team and enhance your position in that field or skill.
6.	_Basics, first_: always follow top-down thinking, starting with the best practices of computer science.
7.	_Think differently_: simple is more complicated than complex, which means you'll need to use your creativity.
8.	_Synthesis is the key to communication_: we have to write code for humans, not machines.
9.	_Keep it plain_: try to keep your designs with a few layers of indirection.
10.	_Clean kipple and redundancy_: minimalism is all about removing distractions.

Most of those principles are coherent with each other and relate heavily to the
well-known Unix [KISS principle](https://en.wikipedia.org/wiki/KISS_principle).

An extended and fascinating book about the practical application of such
principles is Eric S. Raymond's [_"The Art of Unix Programming"_](http://www.catb.org/~esr/writings/taoup/html/), which I
strongly recommend reading. I can also recommend a now-classic volume on the
same topic by John Ousterhout, [_"A Philosophy of Software Design"_](https://web.stanford.edu/~ouster/cgi-bin/book.php). Both outline
practical examples of how minimalism in design can be effectively embraced, with
a focus on doing the right thing sooner rather than later.

The same principles could (or maybe should) be applied even to programming
languages, but this is often a neglected aspect of such a minimalistic approach.
Note that one of the most successful languages of all time is the C language,
which indeed has a straightforward syntax and, as such, cannot be easy to use
correctly (the principle is that what is simple is not necessarily easy, too).
That's because the programmer needs to create her/his own abstractions and
layers to build her/his vision of a software design. It seems that this is
precisely the opposite of the C++ or Java approach, where the entire
specification spans thousands of pages, and many high-level abstractions are
integral parts of the language. The same can be applied to Python nowadays,
which started as a simple language, more readable and clean than Perl, but now
has a wide and articulated specification. Again, hundreds of pages are now
needed to describe a once-simple language, where tons of new features and
abstractions have been added to enrich its expressiveness.  If one considers its
standard libraries and modules, the actual situation appears even worse.  Can
such an approach be considered _easier_? I don't think so. Let me say: how can a
program be considered simple if it relies on hundreds (or even thousands,
including dependencies recursively) of external modules, as well as hundreds
of syntactical constructs and glues?  Some languages also
manage multi-versioned dependencies, allowing a program to cross-depend on
multiple editions of the same module (yes, JavaScript, I'm talking about you),
with the concrete possibility of introducing obscure bugs as a result. At the
opposite extreme, there is the consideration that we only know and deeply
understand what we make.

Minimalism also means actively seeking a balance between these two opposing
approaches, because reusing third-party modules and packages can be an immediate
solution to deadline urgencies, but can also potentially introduce instability
and dependencies on unmaintained software in the long run. 
Long dependency chains where changes happen independently of the main program
focus and are introduced by third-party motivations and reasons - often with wrong
timing for depending projects - can cause breakages at multiple levels.  

Of course, to reach
the right tradeoff, a few things need to be considered: every single programmer
could not be smarter than a lot of libraries and modules out there, where
multiple developers could have spent hours/weeks/months, or even years refining
them. That's true, but it is also true that not all libraries or modules are
written with the same level of quality and effort. For instance, we all know
cases of elementary modules available for Node that could be easily avoided, and
instead are imported for some form of laziness in development.  Even, sometimes
features that need to be used could be only a small portion of the whole
library/module, which could be reimplemented with a very reasonable effort and
time. This approach could be amplified in modern times when AI tools could
significantly increase productivity in such cases. I would simplify these
concepts with some additional mottos:

1.	_Limit your external dependencies_: avoid depending on modules or libraries
    that are not strictly required to significantly reduce the total development
    time, are not rock stable for their interfaces and features, and do not have
    a clear and stabilized roadmap.
2.	_Reproducibility of the software stack is a must_: these days, 
    [a SBOM](https://en.wikipedia.org/wiki/Software_supply_chain) has
    become recommended/mandatory, but it should not only consist in a documentation of external
    dependencies and their versions, but also the full process of building a
    runtime environment should be fully defined and consistent for the long
    term.
3.	_Do not follow the last oh!-so-cool technology_: while that could be done for
    an amateur project to develop during spare time, it is not a good idea
    depending on a technology whose future is not clearly stated, with a
    well-established development team and proven sustainability in the long
    term. I consider a risk even depending on a single company project, and even
    more if it is considered a startup.  Synthetically, this can be generically
    considered as minimalism in coding style.

Moreover, if you are going to use a well-established framework, such as Django,
for developing your mid-to-long-term web project, it is probably better than
using the latest Nodejs-based framework created six months ago that seems the
latest 'big thing'. But that's probably only common sense. Instead, ask yourself
if your project should be created from scratch using a simple _jamstack system_
and some microservices for well-defined and minimal parts. In many cases, that
is more than enough for too many CMS-based sites out there: indeed, I
continuously ask myself why a lot of websites are still based on WordPress, when
most of them could be easily converted into a handful of static pages and simple
JavaScript snippets that they will use in any case. This can be declined in
terms of minimalism in defining computing architectures, which can also allow
scaling up applications more easily.

So minimalism principles can be considered at multiple levels: for programming
languages, libraries, architectures, and design. However, they require skills,
in-depth research, and a significant amount of time to dedicate to continuous
refactoring and meditation about viable alternatives. And that's probably the
key point: developers with deadlines and urgency imposed by PMs are too often
tempted to follow the easiest and richest paths and provide a solution of any
kind without too much meditation on the final balance among efforts, quality,
efficiency, and durability of results.

Of course, about minimalism, an extraordinary citation is due for the whole
[suckless effort](https://suckless.org) on the uncompromising minimalism side.
And [why not?](https://motherfuckingwebsite.com/).

Ok, ok, I'm joking. But you got the point.


