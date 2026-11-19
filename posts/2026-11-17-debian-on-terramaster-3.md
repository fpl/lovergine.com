title: Terramaster NASes with Debian, take three: scaling up.
date: 2026-11-19 19:00
tags: debian, configurations, technology
summary: Notes about Debian on Terramaster units with GlusterFS
---

As is often the case in scientific environments, IT solutions grow chaotically,
often guided by available funds at the wrong moments, or transient choices for
transient goals. Here at work, we are not an exception. Historically, since the
birth of the Copernicus European project, the Earth Observation domain has
become progressively more demanding about storage, due to the frequency and size
of satellite acquisitions, available free of charge for research groups, free to
access, but not without maintenance and processing costs, of course.

As a result, we have progressively explored low-cost solutions for downloading
and processing Sentinel constellation time series. Over a ten-year window, our
needs moved from dozens of terabytes to hundreds of terabytes. We started with
simple Synology-based solutions, very optimistically, only to discover that the
optimism was not justified. When storage needs to scale up, there are no easy
solutions. 

The only comparable IT environments are HPC clusters, which operate at a
completely different order of magnitude in terms of funding. In that context,
the Petabyte order of magnitude is generally achievable by using
proprietary/FOSS [distributed POSIX filesystems](https://en.wikipedia.org/wiki/Clustered_file_system#Distributed_file_systems) 
such as GPFS, Lustre, or even
Ceph. None of them are exempt from problems from time to time. The sad reality
is that maintaining a very large POSIX filesystem requires compromises, and no
single solution fits all requirements, starting from cost to flexibility,
scalability, and reliability. 
I wrote about the hidden costs of maintaining self-hosted storage solutions
[here](https://lovergine.com/storage-is-a-pain-or-why-self-hosting-is-not-always-either-desirable-or-easy.html)

Almost ten years ago, we chose [GlusterFS](https://www.gluster.org/) as an acceptable compromise for a
distributed POSIX filesystem. It is not object storage, but a pure POSIX
filesystem with a simple architecture, which fits our environment, where most
people rely on the folders-and-files abstraction to organize their data. All
nodes and their bricks are equal (no dedicated metadata nodes) and can scale
without major limitations with a reasonable number of nodes. In our experience,
the real bottleneck is network speed, which can introduce high latency and cause
cache issues. 

We are now finally moving our old Synology-based distributed filesystem to a
pool of TerraMaster U12-500 Plus units, installed with Debian 13. Compared with
TerraMaster SOHO products, these rack-mount units can run without any non-free
firmware. You must manually enable the usual 9000 MTU jumbo frame for the 10Gb
network, which is generally required on all connected hosts and also the switch
(in our case, a MikroTik box) to properly manage full bandwidth. We measured
average performance around 200MB/sec, which aligns with the average sequential
speed of 6Gb SATA HDDs.

Regarding using GlusterFS, the most obvious choice is to use it with XFS as the
filesystem for the NAS bricks; this proved in practice to be the optimal
configuration, after not-too-nice experiences with Btrfs on Synology DSM. Still,
it requires some tuning for periodic checks across the various layers of the
storage system. One is about short/long HDD testing, which I already covered in
another post. A trickier aspect is managing possible bit rot in the brick
filesystems from time to time. While Btrfs, with its COW management, can run
low-impact scrubs on both metadata and data, XFS can only partially do the same
for metadata through xfs_scrub, which is also, as clearly stated, an
experimental feature to use at your own risk. In that regard, it is much better
to run GlusterFS scrubbing instead.

While xfs_scrub is as light as the SMART short self-test for HDDs, both RAID
checks and GlusterFS bitrot scrub are heavy operations that should run rarely to
avoid stressing HDDs and systems, and never at the same time. It is mandatory to
avoid overlapping all such operations, and that’s a good reason to use systemd
timers and run the heavy checks in alternating months.

One suboptimal aspect of our solution is the absence of direct LED control for
HDDs, which is unfortunately available only under TOS with a proprietary driver.
This is obviously required for disk replacement from time to time, when needed.
On the other hand, software support is extended to the lifetime of the Debian
distribution, with major upgrades every 3-4 years on average. Also, this is much
more flexible and efficient than using pre-built custom OSes. Of course, if you
prefer dashboards and the usual GUI candy, this isn't a viable choice; a better
option would be TrueNAS, which has a much higher memory footprint,
especially when paired with OpenZFS.
