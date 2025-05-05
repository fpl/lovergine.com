title: Sharing configurations and data among multiple boxes
date: 2025-05-04 23:00
tags: tools, configurations, personal computing  
summary: About sharing of information among boxes
---

Following a [post detailing my email setup](https://lovergine.com/my-geeky-email-setup-explained-to-humans.html) 
across multiple personal boxes,
I'll summarize an outline of my approach for managing data across multiple
workstations and individual profiles in this post. This system (or collection of
tools and workflow) has evolved over time and continues to adapt to various
needs and scenarios, offering high flexibility and control for my use cases.

First of all, it is mandatory to use [git ](https://git-scm.com/) to manage multiple 
configurations
with branches for almost every box or family of boxes (e.g., home vs. work,
personal vs. shared). Some people tend to use git for the whole home, but in my
honest opinion, it is inappropriate for performance reasons, even if Joeyh's
[git-annex](https://git-annex.branchable.com/) 
and LFS mode are helpful in those regards. In many cases, it is
not required to version all data files, and even if this time-machine-like
solution is considered the ideal one for user's homes, it could negatively
impact storage requirements and long-term performances. Also, having a mono-repo
for all your own stuff could be challenging. In my case, I deal with multiple
private and public Git repositories, including GitHub, Gitlab, and others all
around, and maintaining a single repo is not a good idea for me.

The good news is that it is generally possible to limit the use of git to a
subset of the whole home, specifically the dotfiles used to configure common
tools and programs, a helpful set of scripts for personal use, and a few other
sparse things. In many cases, some useful scripts to synchronize and update
everything is more than enough. Part of my automation workflow is based on
Ansible rules, so the whole thing is easily integrated into such management.
 
 It's important to note that I strongly advise against using git for sensitive
 information, such as credentials and keys. Even with a personal git server,
 copying such information via directly attached media storage is safer, ensuring
 they are not exposed on a permanently internet-connected repository. For such
 cases, specific solutions like Vault/OpenBao could provide an extra layer of
 security for workgroups, giving you peace of mind and confidence in the
 system's security measures. That said, the whole topic of the management of
 passwords, credentials, and other private information would require another
 post for completeness because it is not straightforward when privacy and
 security need to be fully conjugated with long-term goals.

## Dot files and other stuff maintenance 

That said, I currently use at least a couple of different git repositories, one
for my dotfiles and one for helpful scripts for personal productivity. These
repositories are branched, at least in home/office flavors, and based on
multiple languages, including shell, Perl, Python, awk, and others.

I found it helpful to clone such repositories immediately, install them via the
GNU [stow](https://www.gnu.org/software/stow/) utility, and install pure symlinks under my *$HOME* and personal
_binaries_ directories. However, for some specific cases (notably the Vim
stuff), I prefer maintaining a separate git repository that I update separately:
this is partially for historical reasons, but even because, in some cases, the
whole stuff is a fork of other repositories.

In the past, I adopted a _bare_ repository for dotfiles and a custom git call to
maintain all dotfiles directly in place instead of symlinking them, which is a
slightly different approach. Something like the following snippet of shell code:

```bash
	$ echo 'alias dotfiles="/usr/bin/git \
         --git-dir=$HOME/.dotfiles.git/ \
         --work-tree=$HOME"' >> $HOME/.bashrc
	$ source $HOME/.bashrc
	$ echo ".dotfiles.git" >> .gitignore
	$ git clone --bare <my_git_host>:/opt/git/dotfiles.git \
            $HOME/.dotfiles.git
    #
    # clean up current dotfiles (with directories) 
    # available in the common repository and backup
    #
	$ mkdir -p .dotfiles-backup && \
		  dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
		  xargs -I{} dirname {} | sort | uniq | xargs -I{} mkdir --parents \
          .dotfiles-backup/{} && dotfiles checkout 2>&1 | \
          egrep "\s+\." | awk {'print $1'} |  \
  		  xargs -I{} mv {} .dotfiles-backup/{}
	$ dotfiles checkout
	$ dotfiles config --local status.showUntrackedFiles no
```

can be used with a proper alias to maintain all registered dotfiles in each
box's HOME. Of course, the previous stow-based approach is much more immediate.

## Gnome configuration

My dotfiles repository does not include the main desktop configuration,
specifically my Gnome settings, including the few extensions I use. Not all my
personal boxes include a desktop, but it is much more immediate to maintain a
single dump of a finalized configuration based on the main Gnome version in use
instead of branching and following its internals properly (which can largely
change from one version to another).

```bash
	$ dconf dump / >gnome-settings.dump 	# on the source workstation
	$ tar czvf gnome-shell.tgz .local/share/gnome-shell

	$ dconf load / <gnome-settings.dump 	# on the target workstation
	$ tar xvf gnome-shell.tgz
```

## Data syncing and backups

While code and configurations are better managed via git, I also deal with many
generic data files (up to dozens of GBs per file or more) and documents that I
synchronize automatically or on demand. Two tools I use intensively —
[syncthing](https://syncthing.net/)
and [unison](https://www.cis.upenn.edu/~bcpierce/unison/) — can cover both goals. 
They require at least one _master_ copy to be
reachable, and having one master host per site is the best idea.

Finally, my primary backup tool for years has been the venerable 
[borg ](https://www.borgbackup.org/) tool,
which allows planning incremental backups and rotation plans of master hosts. At
least one encrypted backup is stored on an external cloud for convenience. This
is an aspect where I'm still looking for a definitive solution far from the
usual big companies for personal stuff (a fight lost at work, unfortunately),
specifically for what is attaining the mobile ecosystem and family. That's
because, but for strictly FOSS requirements, I'm also interested only in a
self-hosted, long-term, and stable solution that I could directly maintain for a
lifetime. Currently, I'm simply using [rclone](https://rclone.org/) 
to sync third-party cloud storage
when required.  Of course, the [3-2-1 rule for backup](https://en.wikipedia.org/wiki/Backup) 
is fully respected, thanks
to the use of multiple sites and devices, even without using cloud providers,
but I would prefer taking in the loop additional encrypted copies of some stuff
(mainly videos and photos) even for sharing with others. 
