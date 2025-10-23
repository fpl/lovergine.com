title: Installing Debian on a USB stick for a Terramaster NAS
date: 2025-10-15 18:00
mastodon: https://floss.social/@gisgeek/115379067992395810
tags: debian, configurations, personal computing, technology
summary: Installing Debian on a USB stick for use with a Terramaster NAS
---

I recently bought a basic NAS for home use. The NAS is a nice [Terramaster
F2-425](https://shop.terra-master.com/it-it/products/f2-425), which is a very
basic RAID1-only NAS with a decent CPU and 2.5Gb network. Terramaster allows
users to either use its custom Linux-based TOS or install any other operating
system supported by the x86_64-based platform. Note that this model does not
mount any NVME unit for the OS, as for the F2-424.

Common choices include TrueNas, Proxmox, or any other Linux-based distribution.
My choice has been a plain Debian stable distribution because I do not have
special requirements and prefer a lightweight CLI-only solution over a
dashboard. The F2-425 does not have NVME cards, only regular HDDs/SSDs.
However, when installing an independent OS, as in my case, you can immediately
use an external USB stick for the system, and dedicate HDDs to data. The unit
even has a tiny (264MB) internal USB stick for installing TOS, but I simply
used a decent 16GB SanDisk thumb drive. The clear advantage is the possibility
of having the base system and data perfectly separated, and multiple copies of
the stick for safety.

Of course, the installation of such a system can be done without using the
Debian installer at all, so I'm describing here how to perform such an
installation for my future reference and for other geeks. Of course, you need a
running Linux system with _debootstrap_ installed. The process involves
partitioning the stick in GPT mode, installing the base system and EFI, and
configuring the system to finalize a bootable system with the necessary
software to connect the NAS to the network, including OpenSSH.

Note that the 2.5 Gb Ethernet is a RealTek, so a firmware blob
(firmware-realtek package on Trixie) is required to properly work with that.
Alternatively, another of the USB ports could also be used to add a wireless
connection. The OS stick could be simply mounted on the internal port, but it
requires opening the chassis for that and using a tiny stick.

At power-on, the internal TOS dongle automagically boots up, so connecting an
HDMI display and a keyboard is required to change the setup to boot the Debian
EFI image on the stick. On F2-425, press the <F12> key to access the AMI setup
and change boot priorities. There are always slight differences among AMI BIOS
setups, so it is required to find the right key to access settings and change
boot options.

Let's consider /dev/sde as the name of the USB stick device on the host where
it will be prepared. A GPT partition can be created via GNU parted, as follows:
```
parted /dev/sde 	# to create EFI and root primary partition
partprobe --summary /dev/sde
sfdisk -l /dev/sde
mkfs.vfat -F 32 /dev/sde1
mkswap /dev/sde2
mkfs.ext4 /dev/sde3
```

Once done, installing the base system is immediate.

```
mount /dev/sde3 /mnt
mount /dev/sde1 /mnt/boot/efi
debootstrap trixie /mnt

mount -o bind /dev /mnt/dev
mount -t devpts devpts /mnt/dev/pts
mount -t proc proc /mnt/proc
mount -t sysfs sysfs /sys /mnt/sys
mount -t tmpfs run /mnt/run

cp /etc/apt/sources.d/debian.sources /mnt/etc/apt/sources.d/.
cp /etc/resolv.conf /mnt/etc/.

echo "nas" > /mnt/etc/hostname
sed -i -e 's/localhost$/localhost\n127.0.0.1\tnas/' /mnt/etc/hosts

rootfs=$(blkid /dev/sde | grep TYPE=\"ext4\"|awk '{print $2}'|cut -d\" -f2)
vfat=$(blkid /dev/sde|grep TYPE=\"vfat\"|awk '{print $2}'|cut -d\" -f2)
swap=$(blkid /dev/sde|grep TYPE=\"swap\"|awk '{print $2}'|cut -d\" -f2)

cat >/mnt/etc/fstab <<EOF
UUID=$rootfs / ext4 noatime,errors=remount-ro 0 1
UUID=$vfat /boot/efi vfat noatime,umask=0077 0 1
UUID=$swap none swap sw 0 0
EOF

chroot /mnt
apt update
apt upgrade -y
apt install grub-efi-amd64 linux-image-amd64 ssh \
        firmware-misc-nonfree \
        firmware-realtek xfsprogs rsync pmount \
        gddrescue screen util-linux-extra bash-completion \
 	mdadm  parted smartmontools htop ntp unattended-upgrades sudo
useradd -m -G sudo -s /bin/bash -C 'Your Name' your_username 
passwd your_username
adduser your_username plugdev
apt install tzdata locales
dpkg-reconfigure locales
grub-install --target=x86_64-efi --force-extra-removable /dev/sde
update-initramfs -u
apt clean
exit # leave the chroot
umount /mnt/run
umount /mnt/sys/firmware/efi/efivars
umount /mnt/sys
umount /mnt/proc
umount /mnt/dev/pts
umount /mnt/dev

```

Note that required HDDs can be easily installed later. I manually configured
the two disks with GNU parted for a GPT Linux RAID partition.  After booting
with the stick, a simple install of the md array support suffices.  Typically,
the USB stick runs as `/dev/sdd` 

```
sudo mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sda1 /dev/sdb1
mkfs.xfs /dev/md0
mkdir /data
data=$(blkid /dev/md0|grep TYPE=\"xfs\"|awk '{print $2}'|cut -d\" -f2)
echo "UUID=$data /data xfs defaults 1 1" >>/etc/fstab
```

In order to allow shutting down by pressing the power button, it is required to
configure `systemd-logind` as follows.

```
sed -i -e 's/^#HandlePowerKey=poweroff'/HandlePowerKey=poweroff/ \
       -e 's/^#HandlePowerKeyLongPress=ignore/HandlePowerKeyLongPress=ignore/ \
	/etc/systemd/logind.conf

systemctl restart systemd-logind.service
```

It could also be a good idea to stop the periodic auto-scan on the RAID volume
for big disks, which can take ages to run.

```
sed -i -e 's/^AUTOCHECK=true/AUTOCHECK=false/' /etc/default/mdadm
systemctl restart mdmonitor.service
```

The network configuration depends definitively on the type of connection used
and the home network setup. In my case, the NAS uses a static IPv4
address, so it can be configured through `ifupdown`, and it is only necessary
to correctly write the `/etc/network/interfaces` for the `enp1s0` Realtek 2.5Gb
Ethernet interface. Not that it requires a non-free firmware blob to run.

After the initial syncing, a series of software to better manage the NAS can be
installed, but that is optional and can be the subject of a different post. For
sure, for better convenience, a copy of the USB stick with the complete
configuration is a good idea, to allow a fast recovery in case of failures.


