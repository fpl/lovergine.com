title: Again about AI, copyright, uses and abuses
date: 2025-04-29 20:00
mastodon: https://floss.social/@gisgeek/114425856968862420
tags: development, ai, aiad, copyright
summary: About AI-aided and copyright
---

My [last post](https://lovergine.com/ai-artifacts-copyright-and-electric-sheep-dreaming.html)
dealt with some ideas about copyright that need more in-depth
analysis. First, as it was common in the old good days, _IANAL_ applies to this
post and the whole topic.
The final results of current litigations in courts that touch on some of the
primary companies involved in the whole AI thing could ultimately differ from
what is now the common sense point of view (mine). This post could become
rapidly obsolete, so another disclaimer is due for this aspect, too.

A nice summary of the matter in the summer of 2024 can be read in [1].

I have to partially fix the assertion I made about copyright by Anthropic/Google and
whatever company in a certain sense. At least for US copyright law, anything
directly produced by non-humans is (or seems currently) not admissible for
copyright coverage [2]. As you know, there are a few differences between
different jurisdictions, specifically the US and the rest of the world. That's
the reason why, indeed, Joseph Borg and Galyna Podoprikhina by WH Partners [3]
say:

```
Despite the "common" belief that a work can be only be
protected by copyright if it is created by a human, one must
bear in mind that copyright laws are not uniform around the
world, especially when it comes to AI-generated work, or a
work created with the assistance of AI. Currently, apart
from the UK as described above, AI artwork is also subject
to copyright in Ireland, India, and New Zealand.
```

If a photo taken with a camera is admissible for copyright, the same could be
claimed for any other tool, one could say. In the past centuries, even
photography would have been indubitably not initially admitted to copyright and
the artistic scene: indeed, a painting is a lot different from a photo. A modern
photographer would not agree with such mortification of her/his work. Today, the
reality is quite different, and photography is fully accepted among modern arts,
with all implications about intellectual property and copyright.
 
Most authors agree with the significance of the human contribution to the work
to define a copyrightable work, but how this contribution could be quantified is
obscure. The number of prompts and replies, as well as the size of context
contributions, are significant and sufficient efforts, or should they be
quantified in LOCs and the size of direct patches to the AI artifacts? And in
that case, what is the percentage of human-driven contribution that represents
the threshold for deciding if the work is copyrightable or not? I'm afraid that
the final verdict is something to decide in a court, as in cases of plagiarism.

But for AI, for ages, we also had RAD and no-code/low-code utilities that seemed
the future of development for specific applications, with all their limitations
(not too different from AI ones, to be fair). Even in those cases, copyright
claims could be problematic. 

That said, there is also the problem of training possibly performed without
authorization. While most of the FOSS software is covered by one of the OSI
licenses, not all licenses are compatible with each other, so the resulting LLM
model is questionable and possibly unfair. I will ignore, for decency, the
eventual use of proprietary content for the purpose of training, which already
seems to be the subject of lawsuits by multiple parties in some contexts: see 
for instance [4] and [5].

As written in [2], the final destination of the whole topic is still foggy and
unclear. Multiple parties are involved, and a series of lawsuits and claims are
pending. This seems to be the reason why some companies explicitly deny the
possibility of using AI tools in their developers' daily work. Due to their
pervasive diffusion at multiple levels, this becomes increasingly difficult to
avoid. As often in the past, tools are still forward than rules and sh*t could
happen in a not so far future.

## References

1. [Who Owns Claude’s Outputs and How Can They Be Used?](https://terms.law/2024/08/24/who-owns-claudes-outputs-and-how-can-they-be-used/)

2. [AI-Generated Content and Copyright Law: What We Know](https://builtin.com/artificial-intelligence/ai-copyright)

3. [AI-Generated Art: Copyright Implications](https://whpartners.eu/news/ai-generated-art-copyright-implications/)

4. [Authors sue Anthropic for copyright infringement over AI training](https://www.theguardian.com/technology/article/2024/aug/20/anthropic-ai-lawsuit-author)

5. [Generative AI Lawsuits Timeline: Legal Cases vs. OpenAI, Microsoft, Anthropic, Nvidia, Perplexity, Intel and More](https://sustainabletechpartner.com/topics/ai/generative-ai-lawsuit-timeline/)

