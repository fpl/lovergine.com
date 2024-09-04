title: Playing with Vagrant, Virtualbox and Guix
date: 2024-09-04 18:20
tags: virtualbox, vagrant, guile
summary: Some notes about Guix in Virtualbox and Vagrant
---

It is specifically convenient using `Guix-the-system` within a _foreign distribution_, 
such as Debian, for development and tests. The package management
system can be used on top of the system, but I find it quite interesting to
explore the potential of the Guix distribution in the context of virtualized
environments. For personal use, that is also the ideal way to avoid breaking
your own daily boxes every couple of days with daredevil approaches to personal
computing.
 
I find it quite handy to use [Vagrant](https://www.vagrantup.com/) to synthetically describe multiple virtual hosts within a virtual network, by means of a single `Vagrantfile`. Nowadays, there are
multiple _virtualization systems_ usable for the same purpose, including the `libvirt` ecosystem. Under the hood, those systems can generally manage multiple virtual machine engines (or even cloud systems). Vagrant under Debian can use either [_Libvirt+KVM_](https://libvirt.org/) or [_Virtualbox_](https://virtualbox.org/) (the default one used by the upstream Vagrant) as primary engines.

Users can develop their own Vagrant images (called _boxes_) or use those made available on the Hashicorp cloud, as developed by third-party teams (which is the common case). 

Unfortunately, while there are [a handful](https://app.vagrantup.com/debian/) of Debian boxes developed by [the Debian Cloud Team](https://wiki.debian.org/Teams/Cloud/VagrantBaseBoxes), like many other ones for multiple distributions and releases, this is not the case for Guix. At the time of this post, there is only [a single box](https://portal.cloud.hashicorp.com/vagrant/discover?query=guix) created some years ago by [Tom Parker-Shemilt](https://github.com/palfrey/).

Of course, the Guix team also made a `qcow2` image available to run a virtualized desktop machine under a QEMU/KVM system, as explained [in the manual](https://guix.gnu.org/manual/en/html_node/Running-Guix-in-a-VM.html). What is described in this post can also be easily applied to create an alternative custom implementation with QEMU. What is required is to create a virtual disk image of some kind and use it to populate a custom distribution configuration via `guix`. The resulting image will be runnable under a suitable virtualization system in the host foreign distribution.

Let's assume to use any recent version of Vagrant and Virtualbox, both installed on the host system, along with the Guix package manager. The following are the steps required to create a Vagrant box with a minimal configuration of Guix that is compatible (with some limitations) with Vagrant and can be used to run any number of Guix VMs. Each Guix vm can be reconfigured for specific goals using multiple configurations.

In this case, we will not need to use [Packer](https://www.packer.io/) to prepare a box because the `vagrant package` command directly supports Virtualbox images with the same purpose.

 - Create an empty [virtual disk](https://en.wikipedia.org/wiki/Virtual_disk_and_virtual_drive) image and partition it.
 - Prepare a suitable configuration written in Guile for Guix.
 - Run an initial setup of the mounted virtual disk using `guix` on your host.
 - Create a basic Virtualbox machine and attach the virtual disk to it.
 - Convert the machine into a Vagrant box and register it.
 - Prepare a Vagrantfile snippet and run the vm(s).
 - (Re)configure vm(s) on the basis of your needs.
 - Done!

## Create a virtual disk image and partition it

This is the straightforward part. Here, I'm using the `vdi` format, the native Virtualbox one, but the VMware `vmdk` format can be used instead.

```
 # load the Network Block Device module
 sudo modprobe nbd
 # create a thin device
 qemu-img create -f vdi guix-hd.vdi 100G
 # ... mount it
 sudo qemu-nbd -f vdi --connect=/dev/nbd0 guix-hd.vdi
 # ... partition it 
 sudo parted /dev/nbd0 mklabel msdos
 sudo parted -a cylinder /dev/nbd0 mkpart primary ext4 1 93G
 sudo parted -a cylinder /dev/nbd0 mkpart primary linux-swap 93G 100%
 sudo parted /dev/nbd0 set 1 boot on 
 # ... create a suitable fs
 sudo mkfs.ext4 /dev/nbd0p1
 sudo mkswap /dev/nbd0p2
 # ... have a look to the partions IDs
 sudo blkid /dev/nbd0p1 
 sudo blkid /dev/nbd0p2
 # ... mount the root fs
 sudo mount /dev/nbd0p1 /mnt 
```

## Prepare a suitable configuration written in Guile for Guix

Any valid configuration can be prepared, in this case this is a minimal one with
a pair of changes for Vagrant. Specifically, a `vagrant` user in the `wheel`
group needs to be added, and it should be able to run sudo without a
password. Even, the unsecure Vagrant key needs to be authorized to access via ssh. 

Note that the key is added at the system level, and the root user has no password,
which should be appropriately changed after the first run or, even better, at
provisioning time. That is a requirement if the box would be exposed on public
network, because the default private and public keys of Vagrant are publicly distributed.

That is usually and automagically done by `vagrant` at first boot, but Guix is a read-only system
and - as we will see - the Guix system is still not completely supported by
Vagrant.

```
ROOTFS_UUID=$(sudo blkid -o value /dev/nbd0p1|head -1)
SWAP_UUID=$(sudo blkid -o value /dev/nbd0p2|head -1)
DEVICE=/dev/nbd0

# Download the unsecure ssh key used by Vagrant
wget -q -O vagrant.pub https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub

cat >guix-config.scm <<EOF
;; Indicate which modules to import to access the variables
;; used in this configuration.
(use-modules (gnu))
(use-modules (gnu system))
(use-modules (gnu services avahi))
(use-service-modules desktop networking ssh)

;; Prepare a salt function for a less silly password encryption
(set! *random-state* (random-state-from-platform))
(define str "0123456789abcdefghijklmnopqrstuvwxyz")
(define rnd-chr (lambda () (string-ref str (random (- (string-length str) 1)))))
(define salt (lambda () (string-append (string (rnd-chr)) (string (rnd-chr)) (string (rnd-chr)))))

(operating-system
  (locale "en_US.utf8")
  (timezone "Europe/Rome")
  (keyboard-layout (keyboard-layout "us" "intl"))
  (host-name "guix")

  ;; The list of user accounts ('root' is implicit).
  (users (cons* (user-account
                  (name "vagrant")
                  (comment "Vagrant user")
                  (group "users")
                  (home-directory "/home/vagrant")
                  (password (crypt "vagrant" (string-append "\$6\$" (salt))))
                  (supplementary-groups '("wheel" "netdev" "audio" "video")))
                %base-user-accounts))

  ;; Packages installed system-wide.  Users can also install packages
  ;; under their own account: use 'guix search KEYWORD' to search
  ;; for packages and 'guix install PACKAGE' to install a package.
  (packages (append (list (specification->package "nss-certs")
                          (specification->package "rsync"))
                    %base-packages))

  ;; Below is the list of system services.  To search for available
  ;; services, run 'guix system search KEYWORD' in a terminal.
  (services
   (append (list (service dhcp-client-service-type)
                 (service openssh-service-type
                    ;; here the official unsecure Vagrant ssh key is used...
                    (openssh-configuration
                      (authorized-keys \`(("vagrant" ,(local-file "vagrant.pub")))))))

           ;; This is the default list of services we
           ;; are appending to.
           %base-services))

  ;; Authorize vagrant to run sudo without password.
  (sudoers-file
    (plain-file "sudoers"
                 (string-append (plain-file-content %sudoers-specification)
                                "vagrant ALL=(ALL) NOPASSWD: ALL\\n")))

  (bootloader (bootloader-configuration
                (bootloader grub-bootloader)
                (targets (list "$DEVICE"))
                (keyboard-layout keyboard-layout)))
  (swap-devices (list (swap-space
                        (target (uuid
                                 "$SWAP_UUID")))))

  ;; The list of file systems that get "mounted".  The unique
  ;; file system identifiers there ("UUIDs") can be obtained
  ;; by running 'blkid' in a terminal.
  (file-systems (cons* (file-system
                         (mount-point "/")
                         (device (uuid
                                  "$ROOTFS_UUID"
                                  'ext4))
                         (type "ext4")) %base-file-systems)))
EOF
```

## Run an initial setup of the mounted virtual disk using `guix` on your host

The `system init` can be run more than once, if required.

```
sudo guix pull # only if needed to update packages...
sudo guix system init guix-config.scm /mnt
sudo umount /mnt
sudo qemu-nbd --disconnect /dev/nbd0
```
## Create a basic Virtualbox machine and attach the virtual disk to it

Now, the virtual disk should already be registerd and visibile under your Virtualbox configuration.
```
VDI_UUID=`vboxmanage showhdinfo guix-hd.vdi|grep ^UUID|awk '{print $2}'` && echo $VDI_UUID
```
should show the hexadecimal code associated to the now populated disk. It is now possible to create
a simple virtual machine, for instance:

```
vboxmanage createvm --name=Guix --default --ostype=Linux_64 --register
vboxmanage modifyvm Guix --memory=4096 --cpus=2 --ioapic=on --vram=256 --cpu-profile=host \
                --audio-enabled=off --usb-xhci=off --usb-ehci=off --usb-ohci=off --mouse=ps2

```
and attach the virtual disk to it, as follows:
```
vboxmanage storageattach Guix --storagectl=SATA --type=hdd --port=0 --device=0 --medium=$VDI_UUID
vboxmanage showvminfo Guix
```

## Convert the machine into a Vagrant box and register it

The resulting vm can be directly used under Virtualbox, but the final touch is creating a proper Vagrant box to recycle and possibly publish on the cloud.
```
vagrant package --base Guix --output guix-small.box
vagrant box add guix-small.box --name=guix-small
vagrant box list
```
Now the new box is ready for use in multiple configurations within a `Vagrantfile`.

## Prepare a Vagrantfile snippet and run the vm(s)

A simple `Vagrantfile` can be used to create an instance of the box, such as:

```
Vagrant.configure("2") do |config|
	config.vm.define "guix1" do |vm1|
	 vm1.vm.box = "guix-small"
     vm1.vm.network "private_network", ip: "192.168.1.2"
	 vm1.vm.provider "virtualbox" do |vb1|
	    vb1.memory = "8192"
		vb1.name = "guix8G"
		vb1.cpus = 4
	end
    config.vm.provision "shell", inline: <<-SHELL
        guix pull
        guix install htop 
     SHELL
	end
end
```
A new machine can be created, started up and connected easily, with also an initial provisioning, by issuing:

```
vagant up guix1
vagrant ssh guix1
```

## (Re)configure vm(s) on the basis of your needs

Both the box and the dependent virtual machines can be reconfigured as usual by `guix system reconfigure` in the guest
or even remounting the original virtual disk (or any of the `vmdk` copies cloned by Vagrant) as previously done, then 
re-issuing a `system init` with a new Guile configuration. Note that the same `reconfigure` can also be run as described
[in the manual](https://guix.gnu.org/manual/devel/en/html_node/Chrooting-into-an-existing-system.html).

## Missing features in Vagrant to support Guix

Vagrant needs to recognize the installed system in order to perform a few operations, but unfortunately that is still not the
case for Guix. Specifically, that prevents the capability of halting the system, which is not exactly a nice thing. That must
be done manually by running `halt` within an ssh session. For the same reason, Vagrant is not able to fully configure networking,
so the second network interface shown in the previous `Vagrantfile` needs to be configured manually by adding a suitable 
`static-networking-service-type` section to the Guile configuration.

A suitable support would need to be added as a proper 
[vagrant plugin](https://developer.hashicorp.com/vagrant/docs/plugins/guests)
as in the case of other operating systems and distributions. 
So, good but not good enough, maybe it is matter for another post, even if I'm not exactly a Ruby language fun.

In the meantime, have a good time by upping and destroying Vagrant Guix boxes.
