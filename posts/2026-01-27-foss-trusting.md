title: How to trust FOSS players and the security implications
date: 2026-01-27 17:30
mastodon: https://floss.social/@gisgeek/115967979580713005
tags: foss, technology, governance, development, security 
summary: The matter of trusting FOSS contributors for security
---

More and more, recent (and not too recent) episodes [1-5] nowadays show a hard truth
we already discovered in the Debian project since the end of the 90s. A key
security principle in FOSS code development is ensuring the trustworthiness of
all parties involved, and that’s unfortunately also the weakest part of the
whole chain.

Debian adopted a long time ago a tentative GnuPG-based screening of people
involved in the project through the so-called [Web of Trust](https://en.wikipedia.org/wiki/Web_of_trust). 
All developers need
to participate in eyeball meetings to sign each other's public keys after
verifying personal IDs. The more signatures, the more trustworthy. That is
generally mandatory before being granted the privilege of uploading to the main
archive without review. Of course, trust is not automatic, and each volunteer
must demonstrate they have the required skills and good intentions, and embrace
the Debian social contract. This is the annoying, often multi-year process to be
accepted as a contributor.

This process is far from perfect and may also be subject to abuse, as Martin
Krafft demonstrated at a past DebConf, a long time ago. One of the main issues
is that maintainers work on upstream software that generally does not undergo
such a process to accept contributors. As the well-known sad case of the xz
utils demonstrated [6] a couple of years ago, an initial review of pull requests is
not generally enough to ensure that the developer or group does not have evil
intentions in the mid- to long-term. Also, with the best intentions of sane
upstream developers, evil parties can make very creative efforts to hide their
malware code. This is magistrally demonstrated in that episode, which did not
cause major security issues, only by casualties.

The sad reality is that none of the main programming language hubs is really
trustworthy, because literally anyone can register anonymously to upload code
and participate in development teams. Core teams at least review pull requests
before accepting them to avoid major abuses. To address this, enforcing a
worldwide web of trust for all core projects and possibly all software hubs
should be considered a mandatory step to improve security and accountability. 

It does not resolve all problems, but it helps. A central authority is not the
answer, as it could create more problems than it solves. Instead, enhance
trustworthiness by encouraging ongoing cross-review by multiple parties.
Establish processes that build developers' trust over time through active
participation and transparent peer review. While key hijacking remains a risk,
this is a separate issue requiring distinct protective measures.

I've written about [this related issue before](/are-distributions-still-relevant.html). 
The shift from distributions to
language and upstream hubs shifts software management onto developers and users,
increasing the risk of security incidents from malicious contributions. 

That said, like it or not, most FOSS products out there are created/maintained
by single individuals and micro-development teams with no warranties and
questionable durability. I wonder how billion-dollar companies can seriously
consider basing their core business in such conditions, a problem directly
connected to the broader sustainability challenges for FOSS projects. The
progressive spread of the AGPL license and other similar licenses is a symptom
of this type of malaise and should be taken into consideration, as they are
different aspects of the same problem. Security concerns are another key point
that we, as a community, should try to manage better, but my honest thought is
that nowadays, predatory big (and not so big, even) companies (as well as public
bodies too) that use community-driven FOSS code in an unfair manner, without
returning a cent for development and maintenance, are not more acceptable.

Therefore, FOSS communities are not perfect, but many of the culprits are
nowadays on the shoulders of companies and public bodies that are still looking
out their windows instead of being active stewards and promoting reciprocal
collaboration among all involved parties.

Come on, put the money and effort into the sources of your digital profits.

## References

1. [Malicious PyPI Package Impersonates SymPy, Deploys XMRig Miner on Linux Hosts](https://thehackernews.com/2026/01/malicious-pypi-package-impersonates.html)
2. [Threat actors misuse Node.js to deliver malware and other malicious payloads](https://www.microsoft.com/en-us/security/blog/2025/04/15/threat-actors-misuse-node-js-to-deliver-malware-and-other-malicious-payloads/)
3. [Node.js Malware Campaign Targets Crypto Users with Fake Binance and TradingView Installers](https://thehackernews.com/2025/04/nodejs-malware-campaign-targets-crypto.html)
4. [Two New RubyGems Laced with Cryptocurrency-Stealing Malware Taken Down](https://www.sonatype.com/blog/rubygems-laced-with-bitcoin-stealing-malware)
5. [PHP Pear Vulnerability](https://www.mycert.org.my/portal/advisory?id=MA-714.022019)
6. [https://en.wikipedia.org/wiki/XZ_Utils_backdoor](https://en.wikipedia.org/wiki/XZ_Utils_backdoor)
