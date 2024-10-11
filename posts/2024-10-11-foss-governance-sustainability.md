title: FOSS governance and sustainability in the third millennium
date: 2024-10-11 17:45
tags: foss, governance 
summary: Some reflections about FOSS and its governance
---

I have long participated in the FOSS community. My first public contribution was the [YardRadius](https://github.com/fpl/yardradius) project in 1995, a consolidation of the old [Livingston](https://en.wikipedia.org/wiki/Livingston_Enterprises) [Radius](https://en.wikipedia.org/wiki/RADIUS) daemon and a series of add-ons written by Christian Gafton (RIP) and me. That was some years before the more significant FreeRadius project. At that time, I ran for a period an [ISP](https://en.wikipedia.org/wiki/Internet_service_provider) just before the _dotcom bubble_ exploded, but that's another story...

That was when most of the code was written in C (sometimes C++) and a handful of _parvenu_ scripting languages such as Tcl, Perl (version 5 would be released one year later), or the still fresher Python.

At that time, the GNU project had already been active for more than ten years, the Linux kernel was less than five years old, and the whole FOSS thing was in its infancy for most of the world, but for a group of hackers and visionaries. Indeed, it was still seen with suspicion and fear in the business area, if not explicitly fought.

Being a FOSS company was an exception, not a viable opportunity. In those years, the only credible company was probably RedHat Inc. in the USA, while other companies (such as MySQL AB in Sweden) still had to gain momentum. To my memory, almost no FOSS company was probably located in the EU at the time. Sourceforge or Freshmeat still had to appear, and FOSS tarballs had to be merely searched via Google search through rigorously _indie_ websites.

Fast-forward almost thirty years. FOSS development has become mainstream, including for the same companies that used [FUD](https://it.wikipedia.org/wiki/Fear,_uncertainty_and_doubt) at the time to fight it (Microsoft, yes, I'm talking about you). Every developer proudly creates their FOSS portfolio of tiny or more considerable project contributions through Github to collect gadgets and show their own skills. There are more FOSS projects than single developers, and so on.

Apparently, all has gone well, but for a couple of details, now, like then. Those details are the governance and sustainability of FOSS projects, which are strictly connected to their credibility. There are very few (maybe no one) articulated projects that are conducted by a handful of developers for a significant duration, and even fewer just for free (like beer).

In those regards, I can consider [SQLite](https://www.sqlite.org/draft/crew.html) and its well-known geospatial extension [Spatialite](https://www.gaia-gis.it/fossil/libspatialite/index), as well as a few other projects in the past, such as OpenSSL. They all survived a pretty long time, with quite regular releases, but not without sustainability problems from time to time. See, for instance, [the issues of Spatialite](https://groups.google.com/g/spatialite-users/c/vKLokX4aSVU/m/qNDZDBoSAwAJ). That could be specifically grave when security is involved, and the software is a reverse dependency for many others (as happened to OpenSSL).

The hard truth is that any complex software requires years of work to solve issues and add rock-solid features. Proper architectural choices and automation tools can make the whole effort more manageable and light, but there is no silver bullet to change this fact of life.

If you belong to a tiny pool of developers or a single small company, there is a good probability that you can't simply maintain the same level of effort for long enough. Even in most cases, proper software maintenance is simply a tedious activity. Let me call that with its correct name: it is a grunt work that merely needs to be done. The genuinely creative part is often overwhelmed by tons of boring issues fixing, communication activities, documentation writing, etc.

Of course, the only decent solution is an excellent modular architecture with many people working on independent parts in a decentralized way. But for that, you need excellent organization and tooling, with project governance that ensures the right level of involvement and satisfaction for people. The developers could be paid or not, but in the second case, they must enjoy participating in the project; otherwise, they will leave for others. Paid people at least are paid to work on demand (not based on their goodwill), but they need to enjoy their work equally. Otherwise, the sh*t load will rise to high peaks. That's the reason for having excellent governance, and it is also the reason why I rarely saw a single company FOSS project that was durable.

It is under the eyes of anyone that the most durable FOSS projects are conducted by a multi-actor foundation with a well-defined set of rules (without exceeding bureaucracy) that include some democratic process to make fundamental decisions. Unfortunately, such governance cannot be stated from night to day. The project requires a critical mass of developers/companies and years to accomplish such a result. Most of the FOSS projects are simply not relevant enough to that and should find an umbrella foundation and a more general community that could be helpful for sustainability (let's say FSF, Linux Foundation, or OSGEO for the geospatial world). This type of organization will attract funding and ensure mid to long-term sustainability. This is what I would call _a condition sine qua non_ to ensure the success of a FOSS project.

To be clear, most FOSS projects are doomed to fail and close after a few years because not enough developers, users, or companies are interested in either working on them or sponsoring them to cover their expenses and development time. The alternative for the most conservative and stable is a _de facto_ freezing in the state they are in with only minimal maintenance. Indeed, the Debian archive is full of such programs, which are good enough for use but miss any future evolution plan, if not sporadically. Fortunately, multiple software programs would become obsolete enough to be ignored and replaced by new, more flexible ones. This can be especially true for tooling and languages, but even in general.

Let me now concentrate on the elephant in the room. Who does what in the FOSS world?

## Pure FOSS products companies

I will be clear. Most of the companies whose core business is concentrated on creating and maintaining FOSS tools and products have not had an easy life, and that will not change in the future. They have had a bumping road since the very beginning because the sources of returns are very limited: sponsorships, public funding, customer contracts on side extra modules, etc. In the last fifteen years, all this has become even more complicated due to complex relationships with major cloud providers.
This is evident if one considers the latest known cases of RedHat (acquisition by IBM), Hashicorp (changes of licensing models and successive acquisition by IBM), Elasticsearch (again, changes of licensing models), MySQL AB (acquisition by Sun and then Oracle), and MariaDB (acquisition by K1 private equity), which reveal constant financial issues with this type of model, in a way or another.

I'm pretty pessimistic about the sustainability of such a single-holder FOSS project model. I even consider it neither ethical nor convenient for independent developers to sign copyright transfers and other side agreements whose purpose is maintaining complete control of the source code by the copyright holding company.
That continuously exposes the possibility of the project or license hijacking.

## Companies that _also_ work on FOSS products

That is the easy way, followed by the big companies, that have plenty of incoming sources that are not directly dependent on FOSS products. The FOSS projects are not their core business, but they can be heavily dependent on several of them.
They participate in large projects and can even be influential on the goals and directions of the projects because those products are heavily integrated within their workflows. They can sustain internal teams that work on multiple FOSS projects and pay for costs, meetings, sponsorship, and so on. They can even tolerate working with other companies and a community of independent developers for common goals and even with concurrents sometimes. 
This is the stablest situation and probably optimal, at least until company goals do not change, which could possibly upset the project (ask ex-Google Python core contributors for comments, but there is a long list of examples).

## Companies that work _with_ FOSS products

Most companies and users are merely passive users of multiple FOSS projects, with little skills and will to participate in development and costs. In those regards, things are slowly changing, but the level of awareness of the whole FOSS ethic and development process is still low. Many companies still have an evident _predatory_ (let me simplify, sorry) approach to FOSS software use, too: they like the _free as beer_ part, to say briefly. Their role in the sustainability of the project is not relevant, but they are part of the users community and globally determine its success. They are inevitable and part of life and could be more fair from time to time, thanks to micro-sponsorships and minor contributions (even bug reports).

## Large FOSS projects with an ample community, a tiny minority

Of course, the Linux kernel is an immediate example of this kind of project, which includes a large set of contributors, a large group of companies, and independent developers. Unfortunately, it is a tiny minority of the entire FOSS project family. Often (always?) governed by a foundation but also with ample and diversified funding because the users community and interests are both broad. If all projects were of such kind, the rise of FOSS projects would be delightful. Unfortunately, this is not the general case.
The result is that participating in a FOSS project is generally a choice for life. If you are the initial owner, it is a big responsibility. There could be a steep rise in these years of mainstream FOSS development because there are tons of open-source (more or less) projects out there, often conducted by big companies, too. Gaining interest and funding are challenging tasks. For the average developer team, finding a solid umbrella foundation is the easiest choice, or thinking twice before starting.
For sure, as a developer, I would never sign any additional/conditional agreement about copyright holding and contribution rules with a single company (a small or a big one, that's not the point) because the future of such a project is always uncertain. Sure, any FOSS project can always be forked, but forking governance is never an easy task.

So what? In the short run, FOSS projects sustainability is a voting machine; in the long run, it is a weighing machine: don't feed the hype. Concentrating efforts on solid and well-conducted projects is a must, even more than considering their immediate technical merits or popularity. That's true for developers as for users. If your preferred FOSS project is a single-company show, it is probably doomed. You are warned, these are my elementary 2 cents suggestions to navigate the magic FOSS ocean.

