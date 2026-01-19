title: A Terramaster NAS with Debian, take two.
date: 2026-01-19 13:00
tags: debian, configuration, personal computing, technology
summary: More settings for Terramaster with plain Debian OS.
---

After experimenting at home, the very first professional-grade NAS from
Terramaster arrived at work, too, with 12 HDD bays and possibly a pair of M2s.
NVME cards. In this case, I again installed a plain Debian distribution, but HDD
monitoring required some configuration adjustments to run `smartd` properly.

A decent approach to data safety is to run regularly scheduled short and long
SMART tests on all disks to detect potential damage. Running such tests on all
disks at once isn't ideal, so I set up a script to create a staggered
configuration and test multiple groups of disks at different times. Note that it
is mandatory to read the devices at each reboot because their names and order
can change.

Of course, the same principle (short/long test at regular intervals along the
week) should be applied for a simpler configuration, as in the case of my home
NAS with a pair of RAID1 devices.

What follows is a simple script to create a staggered `smartd.conf` at boot
time:

```
#!/bin/bash
#
# Save this as /usr/local/bin/create-smartd-conf.sh
#
# Dynamically generate smartd.conf with staggered SMART test scheduling
# at boot time based on discovered ATA devices

# HERE IS A LIST OF DIRECTIVES FOR THIS CONFIGURATION FILE.
# PLEASE SEE THE smartd.conf MAN PAGE FOR DETAILS
#
#   -d TYPE Set the device type: ata, scsi[+TYPE], nvme[,NSID],
#           sat[,auto][,N][+TYPE], usbcypress[,X], usbjmicron[,p][,x][,N],
#           usbprolific, usbsunplus, sntasmedia, sntjmicron[,NSID], sntrealtek,
#           ... (platform specific)
#   -T TYPE Set the tolerance to one of: normal, permissive
#   -o VAL  Enable/disable automatic offline tests (on/off)
#   -S VAL  Enable/disable attribute autosave (on/off)
#   -n MODE No check if: never, sleep[,N][,q], standby[,N][,q], idle[,N][,q]
#   -H      Monitor SMART Health Status, report if failed
#   -s REG  Do Self-Test at time(s) given by regular expression REG
#   -l TYPE Monitor SMART log or self-test status:
#           error, selftest, xerror, offlinests[,ns], selfteststs[,ns]
#   -l scterc,R,W  Set SCT Error Recovery Control
#   -e      Change device setting: aam,[N|off], apm,[N|off], dsn,[on|off],
#           lookahead,[on|off], security-freeze, standby,[N|off], wcache,[on|off]
#   -f      Monitor 'Usage' Attributes, report failures
#   -m ADD  Send email warning to address ADD
#   -M TYPE Modify email warning behavior (see man page)
#   -p      Report changes in 'Prefailure' Attributes
#   -u      Report changes in 'Usage' Attributes
#   -t      Equivalent to -p and -u Directives
#   -r ID   Also report Raw values of Attribute ID with -p, -u or -t
#   -R ID   Track changes in Attribute ID Raw value with -p, -u or -t
#   -i ID   Ignore Attribute ID for -f Directive
#   -I ID   Ignore Attribute ID for -p, -u or -t Directive
#   -C ID[+] Monitor [increases of] Current Pending Sectors in Attribute ID
#   -U ID[+] Monitor [increases of] Offline Uncorrectable Sectors in Attribute ID
#   -W D,I,C Monitor Temperature D)ifference, I)nformal limit, C)ritical limit
#   -v N,ST Modifies labeling of Attribute N (see man page)
#   -P TYPE Drive-specific presets: use, ignore, show, showall
#   -a      Default: -H -f -t -l error -l selftest -l selfteststs -C 197 -U 198
#   -F TYPE Use firmware bug workaround:
#           none, nologdir, samsung, samsung2, samsung3, xerrorlba
#   -c i=N  Set interval between disk checks to N seconds
#    #      Comment: text after a hash sign is ignored
#    \      Line continuation character
# Attribute ID is a decimal integer 1 <= ID <= 255
# except for -C and -U, where ID = 0 turns them off.

set -euo pipefail

# Test schedule configuration
BASE_SCHEDULE="L/../../6"  # Long test on Saturdays
TEST_HOURS=(01 03 05 07)   # 4 time slots: 1am, 3am, 5am, 7am

DEVICES_PER_GROUP=3

main() {
    # Get array of device names (e.g., sda, sdb, sdc)
    mapfile -t devices < <(ls -l /dev/disk/by-id/ | grep ata | awk '{print $11}' | grep sd | cut -d/ -f3 | sort -u)

    if [[ ${#devices[@]} -eq 0 ]]; then
        exit 1
    fi

    # Start building config file
    cat << EOF
# smartd.conf - Auto-generated at boot
# Generated: $(date '+%Y-%m-%d %H:%M:%S')
#
# Staggered SMART test scheduling to avoid concurrent disk load
# Long tests run on Saturdays at different times per group
#
EOF

    # Process devices into groups
    local group=0
    local count_in_group=0

    for i in "${!devices[@]}"; do
        local dev="${devices[$i]}"
        local hour="${TEST_HOURS[$group]}"

        # Add group header at start of each group
        if [[ $count_in_group -eq 0 ]]; then
            echo ""
            echo "# Group $((group + 1)) - Tests at ${hour}:00 on Saturdays"
        fi

        # Add device entry
        #echo "/dev/${dev} -a -o on -S on -s (${BASE_SCHEDULE}/${hour}) -m root"
        echo "/dev/${dev} -a -o on -S on -s (L/../../6/${hour}) -s (S/../.././$(((hour + 12) % 24))) -m root"

        # Move to next group when current group is full
        count_in_group=$((count_in_group + 1))
        if [[ $count_in_group -ge $DEVICES_PER_GROUP ]]; then
            count_in_group=0
            group=$(((group + 1) % ${#TEST_HOURS[@]}))
        fi
    done
}

main "$@"
```

To run such a script at boot, add a unit file to the systemd configuration.

```
sudo systemctl  edit --full /etc/systemd/system/regenerate-smartd-conf.service
sudo systemctl enable regenerate-smartd-conf.service
```

Where the unit service is the following:

```
[Unit]
Description=Generate smartd.conf with staggered SMART test scheduling
# Wait for all local filesystems and udev device detection
After=local-fs.target systemd-udev-settle.service
Before=smartd.service
Wants=systemd-udev-settle.service
DefaultDependencies=no

[Service]
Type=oneshot
# Only generate the config file, don't touch smartd here
ExecStart=/bin/bash -c '/usr/local/bin/create-smartd-config.sh > /etc/smartd.conf'
StandardOutput=journal
StandardError=journal
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```

