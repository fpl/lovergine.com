title: Coding with AI, the good and the bad
date: 2025-04-20 17:40
tags: development, ai, aiad
summary: About AI-aided development and my results.
---

Like many other developers, I recently started using some LLM-based AI systems
as helpers for coding in a few languages. I'm not a fan of VSCode, and I prefer
a more traditional approach to coding: I hate to cope with code completion
servers and use one of my preferred editors, Vim or Emacs. Navigating by tags is
more than enough for me. That said, this is the summary of my current experience
in the new world of AI-aided approach to coding (i.e., AI-aided development or
AIAD for brevity). 

There's a clear divide among developers when it comes to AI tools: some love
them, while others are more skeptical. If you're keen to delve deeper into this
topic, [Salvatore Sanfilippo](https://www.antirez.com/latest/0), also known as
`Antirez`, shares some insightful perspectives on [his YouTube
channel](https://www.youtube.com/@antirez).  He provides comprehensive
evaluations of the leading AI models and systems, offering a balanced view of
their strengths and limitations.

Based on my experience, while both Anthropic and Google top models are equally
good enough for use, a big difference is due to their relative UX, which is
incomparable among various systems. Luckily, things are continuously changing in
those areas. Copying and pasting without a clean and accessible per chat/project
assets catalog is definitively a pain. The most effective approach is sharing
pieces of a git-based code base, which is not always possible with all AI
chatbots. Even Salvatore shared a few impressive results about his experiences,
and I can definitively assert that, at least currently, some of those systems
can be quite helpful for some tasks if (and only if) used with a grain of salt.

First and foremost, the most effective use of AI tools starts from very
circumscribed tasks to perform in a step-by-step approach after a well-stated
creation of the context to make choices. In other words, any model must be
conducted by hand in the right direction. It is crucial to use what Claude AI
defines as _projects_ to create a clear context with a general detailed
architecture description and key assets for orienteering the linguistic model.
It is also essential to maintain order meticulously. Being verbose enough and
precise is the key point, and that's typically what a senior profile should be
able to do. Each resulting asset needs accurate reviewing and testing; it is
simply impossible to assume that a simple change in human terms corresponds to
perfectly valid changes in AI assets. What is easy for us could not be for the
AI model and viceversa.

The review should be both stylistic and functional because complicated
programming patterns could be completely unmatched by the AI model. That is
specifically true when documentation about APIs is unprecise or missing the
point. The models even tend to generate redundant code or hallucinated code
snippets that cannot be compiled or interpreted. Sometimes, the AI model
generates incredibly good code at large but presents silly or subtle oversights.
At the end of the day, there is not always a gain in development time; it is
only something different: you spend more time reviewing and fixing bugs than
writing code from scratch. It is essential to cope with the limits of current AI
systems to develop a handy way to compose multiple parts together and keep track
of improvements and fixes in multiple iterations of the process.  During
iterations, it could reach the limits of the AI context and get incomplete or
truncated files, and it is fundamental to have a way to regain the path with
minimal effort. In other words, one has to design a well-formed idea of the
resulting products and all intermediate artifacts.  That's the reason why
seniority and experience are fundamental to using such tools effectively: sorry,
Mr. CEO, engineers are still here to stay and being paid for good work.

Tasks that can be easily covered by current AI models are: 

 * Creation of general documentation and/or comments in existing code.
 * Creation of simple tests from a structured codebase.
 * Translation of code from one programming  language to another, 
   including documental formats, such as XML, JSON, and YAML.
 * Creation or improvement of auxiliary tools and boilerplates.
 * Reviewing and improving existing code by steps.
 * Help in identifying common issues and possibly interesting features.

The average results are good enough for an initial base
of successive analysis and development, and I found the AIAD especially helpful
with activities that I judge seriously dull and time-consuming. It's a relief to
have AI tools that can handle the whole web front-end-related activities, which
I personally find less interesting. 

Using multiple AI models to cross-review a code base and possibly prepare
multiple improvement alternatives while purging the obvious misunderstandings is
also an interesting opportunity. At the end of the day, I judge AIAD as
effective enough, but for the most significant limitation of having a
not-too-extended context size (at least with basic pro/premium profiles). This
intrinsic limit is the source of major problems in the UX, along with still
rough or incomplete interfaces: if you need to review and modify a large code
base, you can easily crash against such limitations and have to apply
intensively a divide-and-conquer strategy to govern hundreds of thousands of
LOCs (but diving into any unknown big code base is anyway so different?). 

Of course, the correct approach is understanding that its use changes
programmers from pure creators to reviewers. In those regards, I generally
consider AIAD a Stackoverflow with steroids: anyone who used SO in the past
found valid and interesting answers to questions along with perfectly misleading
suggestions, and that's not different, and mostly better.

_Disclaimer: I mostly used Claude and Gemini Pro, much less ChatGPT and Deepseek
due to their intrinsic limits for UX._
