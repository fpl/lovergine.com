title: Does HPC mean High-Pain Computing?
date: 2025-09-06 19:40
mastodon: https://floss.social/@gisgeek/115157760290668758
tags: hpc, development, distributions, computing, science
summary: About HPC and users experiences
---

Please, forgive the silly joke in the title of this semi-serious post, but
lately I have been thinking about the strange fate of an area of general
computing that I have spent more and more time in recently, as in the near and
far past. For my job, I have utilized a series of scientific HPC clusters
worldwide to solve multiple computing problems most efficiently by distributing
computation across numerous nodes. Over the last thirty years, all such
platforms have consistently shared the same common characteristics, which
invariably pose a problem in their use for the average scientist 
(often a young/junior dedicated to a short-term project) in any
application domain.

To use Fred Brooks' definition, HPC technologies have both intrinsic and
incidental fallacies for such users category. The intrinsic one is due to the inner
complexity of creating a parallel and distributed solution to any problem,
possibly in a way that does not harm the final implementation due to the
increase in communication time among computational agents. This is already a
relevant problem _per se_, which can often be out of the abilities, knowledge, and
interests of the average researcher in bioinformatics, physics, mathematics,
remote sensing, or whatever other research domain.

The incidental fallacy is instead always due to the accessibility of platforms and the
technologies used for their implementation. At large, all such HPC clusters are
a large pool of multi-core hosts with plenty of memory and connected with
multiple high-speed networks for implementing some sort of multi-tier
distributed POSIX file system and/or object storage.  Users can log in on a
limited number of such hosts that are connected to all others and run some type
of scheduling system (e.g., Slurm or HTcondor) where multiple computational nodes can
be reserved for a limited period of time to execute batch jobs or even an
interactive one (mainly for debugging). In most cases, such clusters can also be
used with some MPI/OpenMP implementations for proper parallel computational
modeling based on message passing among computing agents that run on multiple
cores and hosts, with or without multi-threading. Alternatively, GPUs can also
be reserved and exploited via Cuda/OpenCL. In many cases, such implementations
are vendor-oriented and trigger the need to adopt specific libraries and
compilers that add another layer of complexity to implementations.

The incidental problems start when the casual users discover that all such computing
nodes invariably run some legacy enterprise Linux distribution that is maintained 
for a period of ten years or even more, until a full reinstallation of the whole
cluster. On top of such legacy systems (that are for
any practical use simply unusable as such) these scientific clusters give
essentially a few different mechanisms for creating a general computational
environment:

 * [Environment Modules](https://modules.readthedocs.io/en/latest/) 
 * Containers ([Singularity](https://sylabs.io/singularity/) or [Apptainer](https://apptainer.org/))
 * [Anaconda/Miniconda](https://www.anaconda.com/)-like environment (or free forks like [Miniforge](https://github.com/conda-forge/miniforge))
 * Some specific software/application to run 

But for containers, the other solutions are all binary-based hubs, which could
expose them to possible breakages when the application developed needs to access
exotic language bindings for extensions, and the poor users enter the mysterious
and dangerous world of ABI violations and a chain of broken dependencies. Even,
often, such hubs are not always consistent, and any upgrade by the admin team
exposes them to sudden breakages from night to day.

The final solution (or apparently so) nowadays is using containerization and a
target environment where the user code can find all and only the correct
dependencies and versions for the whole software stack of the application. This,
at least, until the third-party hubs of base distributions and languages ensure
complete consistency and retain past binaries and versions for any
medium/long-term need. Of course, a full source-based stack with proper version
tracking _a la_ [Guix](https://lovergine.com/tags/guix.html) would help to avoid
dependencies on external binary hubs and seems the way to go. Indeed, a small
group of interest in such a solution has existed for a few years, but I am
unaware of so many HPC clusters that consistently propose this kind of
implementation for users. That said, writing Guile Scheme descriptors for
preparing an execution environment may not be within the reach of the average
researcher in biochemistry or astrophysics.

Unfortunately, as I wrote 
[in a past post](https://lovergine.com/are-distributions-still-relevant.html) 
on this digital site, this moves the
whole responsibility of a software stack maintenance onto the shoulders of the
final users, who are often the infamous junior profiles I mentioned before.
These are non-IT specialists who should adopt such HPC platform to implement 
solutions as part of their daily job in their special scientific domain.

The result, to be honest, is that the average researcher simply tries to avoid
the whole thing as soon as possible because of the significant complexity that
the entire thing involves, while the private sector introduced specialistic
roles of data and software engineers to manage such problems properly (which is
the only reasonable approach, indeed).  Adding insult to injury, in some
academic areas, such interests in HPC are also viewed with contempt or as a
waste of time, if not openly discouraged.
 
All this explains why a roundabout in any of the significant HPC clusters
worldwide often guarantees hilarious experiences in terms of who is doing what
and how.

Sometimes, I almost feel like I can hear them swearing...

