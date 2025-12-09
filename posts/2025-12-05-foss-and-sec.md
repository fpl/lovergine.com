title: Too many eyes or too few efforts?
date: 2025-12-07 16:00
mastodon: https://floss.social/@gisgeek/115679063672736382
tags: foss, security, development, governance
summary: 
---

I recently read a [post by Jack
Poller](https://paradigmtechnica.com/2025/12/03/the-open-source-security-myth-why-many-eyes-arent-enough-anymore/)
about the end of FOSS optimism in creating software in recent years. His thesis
is that the myth that the more eyes that look at a piece of software, the higher
its quality, is indeed a myth, and that nowadays it is also a dangerous illusion
when we concentrate the analysis on security.
Commercial software, on the other hand, has processes and resources dedicated to
managing security, which in these times of active AI use could make the
difference.

![shai-Ulud of Dunes](/images/shai_ulud.png)

I agree with such a thesis at large, but with some differences in declination
and sense. It is absolutely true that security requires special skills that most
developers do not have and (above all) are absolutely not interested in having.
This is amplified in the FOSS communities, where many programs and libraries are
not specifically written with security in mind.  On the other hand, currently
most AI-generated security reports are fake and pure hallucinations (e.g., ask
[the Curl maintainer](https://mastodon.social/@bagder/115643479759358245), about the overwhelming number of reports in the last
few years that are clearly generated with help of AI and are pure garbage). 
Therefore, having new AI-based tools for
screening does not simplify the problem neither for software creators nor for
infosec experts. Basically, they still need to do their time-consuming jobs with
resources and efforts: there is not an easy escape for that.

Even, if you like it or not, nowadays FOSS software production is organic to the
commercially supported one, and they are strictly connected. If the security
(and, more generally, the sustainability) of so many FOSS projects today is a
problem, it is also a problem for their commercial counterparts. In other words,
FOSS development has been mainstream for at least the last 20 years: that
implies that the sustainability (and security) problem extends to the entire
supply chain for both FOSS and commercial software.

I already dealt with some of those topics in past posts 
(e.g., have a look [here](/foss-governance-and-sustainability-in-the-third-millennium.html), or [here](/are-distributions-still-relevant.html)), not referring to
security, but to the sustainability of the FOSS ecosystem of
_independent-but-interdependent_ projects. This is a matter of responsability
for both FOSS mantainers and companies, and not something that could be avoided
as a problem for others.


As already written in the past, I can't see a recipe for success, but I'm
quite sure that [overcomplication of information systems](/a-call-to-minimalistic-programming.html) does not help,
but is part of the problem. Too many dependencies, complex frameworks, and architectures are sure highways for
disasters. And that's true for both FOSS and commercial software. The shattering of code hubs among multiple
sources of binaries, packages, images, and distributions is another sure quarry of problems, because
they imply a multiplication of possible origins of issues, as well as the need of sustaining multiple teams and replicating
efforts instead of concentrating them.

_There is great chaos under heaven; the situation is excellent! (Mao Zedong) ._


