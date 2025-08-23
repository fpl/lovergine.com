title: Still, no silver bullet
date: 2025-08-23 19:30
tags: books, development, enterprise, society, ai
summary: About current AI role for software engineering and MM-M
---

I recently re-read the seminal book by Fred Brooks about software engineering,
entitled "The Mythical Man-Month" or MM-M for brevity. Specifically, I read the
paper version of the 20th anniversary, which was revised and reprinted in 1995,
after the first edition of 1975. I did that on purpose, firstly because it is
always a fantastic read, and secondly to understand how much of its contents is
still valid today, exactly thirty years later since its last revision. 

Fred missed in 2022; otherwise, it would still be interesting to know his thinking
nowadays after the LLMs boom and the birth of the AIAD (AI Aided Development) as
a new revolutionary (or often seen as such) tool. Hi, Fred, wherever you are.
It is worth mentioning that AI was already taken into consideration by Brooks at
the time, even if limited to expert systems and other rule-based variants, which
seemed promising and often sold as revolutionary before the mid-90s.  A lot of
the book's contents remained in the history of software engineering, including
the famous [Brooks' Law](https://en.wikipedia.org/wiki/Brooks%27s_law), and the
whole book is still an excellent source of inspiration for any management and
organization of complex intellectual projects (not necessarily limited to
software systems), that heavily includes large teams of individuals.

One of the main theses of the latest book edition is that in the short term of
10 years from its proposition (the original essay was dated 10 years after the
first edition of the book), he did not expect a [_silver bullet_](https://en.wikipedia.org/wiki/No_Silver_Bullet). 
That means no significant technological or managerial development was expected to be able to
improve our productivity in programming by one order of magnitude. Ten years
later, he confirmed the same idea, even considering exceptional tools like
old-generation AI, visual programming, CASE tools, and so on.
Is this thesis contradicted in 2025 by the existence of current AIAD tools,
including chatbots, agents, and AI-empowered IDEs? My honest idea is no. I mean
not now and not for the foreseeable future. The reason is exactly the same as
Fred posed at the time. Reducing _accidental_ problems in software creation
(what AI is able to do) cannot be confused with the _essential_ problems in
software creation: the complexity of defining an articulated task, its
analytical specifications, and an algorithmic solution to solve it.  First of
all, ignore the simplistic case of asking an AI engine to implement a very
_simple_ program. Here, the word simple means truly that. If you can specify a
request by a whatever large manageable token context and formulate your request
in terms of a brief question (let me suppose a question of some dozens of rows),
well, that's probably an example of a simple (or dumb) problem. Too few, too
easy. We are talking about a whole system that is generally difficult to
describe, even in thousands of pages of specifications and documentation,
written collectively by large teams of developers, architects, and domain
experts.

The hard truth is that most of the real-world information systems out there
cannot simply be specified in such a way. We are not able to define an
unambiguous and complete enough specification to describe such systems, not to
mention being truly able to write a complete and neat documentation of it,
including its inner workings and use. We live in a deep illusion about that. The
context size to get the required level of details to avoid bugs and ambiguities
in specification would be impractical for current and even future tools, as well
as for any humans. We would get in any case buggy (i.e., incomplete or
misunderstood) results even if the AI engine were able to avoid hallucinations
(which is not the case) and had no limitations for context size. The presence of
AI hallucinations is only accidental in this regard.

In the current AI tooling, we are simply moving the complexity from the writing
of a formal language step by step to using a natural language with a higher
level of abstraction to express the problem. The complexity is still there, and
it is inherent to the problem. Again, we resolved an accidental difficulty in a
creative manner, not different from moving from assembly to using a modern
programming language. Now the difficulty has moved elsewhere, but it is still
there, and natural language is even more complicated to use compared to formal
language. These difficulties translate into multiple refinements and trials to
try to be more precise and get sensible answers and code in a continuous
iteration. Isn't that so similar to the whole ordinary process of developing a
program? In the most simplistic approach, such a process becomes _vibe coding_,
and iteration could tend to infinity, with a forever loop. The smarter
programmer for an easy task will do that in a reasonable (limited, hopefully)
number of iterations, instead.  Is that a significant improvement of one order
of magnitude? I think not, as in most cases for the past. As in the case of
high-level languages instead of assembly, they improved efficiency in coding as
asserted in MM-M, but not by a whole order of magnitude. The AIAD is again
another helper to solve accidental difficulties. The problem and all its
complexity are still there. Thinking that we found the silver bullet is again
(and again) an illusion or pure marketing.

So why do many CEOs insist on predicting a bright yet unlikely future of AI
agents instead of having developers create applications? Brooks already wrote
about that: there is a profound confusion in exchanging months and men, and an
excess in optimism when approaching software development, even among techies,
but that becomes paroxysmal among managers. None can seriously provide even a
decent and reasonable evaluation of development time starting from incomplete,
ambiguous, or vague specifications: the same simply happens systematically in
overestimating the capabilities of current AI tools.

So what? AIAD is simply yet another tool among those available to developers,
but the management problem of dominating complex projects is still there, with
all its inherent difficulties. And the possibility to use natural language
instead of a high-level formal one is only an apparent simplification of the
process. It looks more familiar and easier, but it is also much more
ambiguous, and the so-called _prompt engineering_ is again a pure optimistic
illusion, an euristhic approach to try to overcome our totally insufficient
capabilities of dominating nuances and semantics.

