title: IPv6 is a matter of freedom, not a technical issue
date: 2024-12-24 12:44
tags: digital rights, internet
summary: 
---

In a recent [lenghty
post](https://blog.apnic.net/2024/10/22/the-ipv6-transition/) Geoff Huston,
chief scientist of the Asian-Pacific Network Information Center, discussed the
status of the IPv6 protocol migration and made some considerations of the future
of that migration. An interesting reading that motivated this brief post.

"[...] the transition to IPv6 is progressing very slowly not because this
industry is chronically short-sighted," the APNIC scientist argued. "There is
something else  going on here. IPv6 alone is not critical to a large set of
end-user  service delivery environments."  Indeed, he believes that we are
already "pushing everything out of the network and over to applications."

Of course, he talked about CDNs, the cloud and the business environment that
transformed the Internet from a network-of-peers to a broadcasting network in
the last twenty years or more. I have already considered [the shattered
Internet](https://lovergine.com/the-shattered-internet.html) as a modern
deprivation of the original spirit of the Big Network. The almost current
irrelevance of the IPv6 migration for many involved parties is a sign of time
and again proof of such a kind of drift for me. We are still around 40% of the
net with a fully operational dual-stack, with the prospective to live in
dual-stack IPs until 2045 or more.

I recently changed ISP at home, abandoning Vodafone and moving to a [human-size
national provider](https://www.ehiweb.it/). The new contract came with a
dual-stack connection that includes a (free-as-beer) /48 IPv6 static class
allocation, as recommended by RIPE, which was not even considered by Vodafone
and other prime-time big telco companies here.  Even my VPS provider gives
free-as-beer IPv6 addresses, which can be attached to my VPS to provide
different services.

Every damn connected device at home now has its own static IPv6 address, which
can be controlled and filtered via my home router. I mean potentially 65535
different devices with their own static addresses. Filtering by source and
destination IPv6 and ports in such conditions for security is elementary, as
well as organizing multiple VPNs for any use.  If you want to expose your home
NAS or any other service out of your home network, even behind a CGNAT
connection (as provided by many ISPs out there with no other chance), using IPv6
is a practical and immediate solution under your complete control. Here in
Italy, if you have a business contract, you can sometimes pay for a static IPv4;
otherwise, you are NATed with a minimal chance of creating easily internal
services among multiple sites.

A nice plus is the drastic reduction of port scanning by bots, which is a sad,
shared experience for anyone who exposes any service to the IPv4 limited space
of addresses: scanning billions of addresses is not for the script kiddies.

For me, IPv6 has the same exact role as [the indie web
movement](https://en.wikipedia.org/wiki/IndieWeb) for users' independence on the
modern Internet. If you are able to act, this needs to be done _now_, not in the
next twenty or thirty years, before all the users would be considered always
only customers or passive subjects.

