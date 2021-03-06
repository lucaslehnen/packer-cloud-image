# Locale Setup
d-i debian-installer/locale string pt_BR.UTF-8

# Keyboard Setup
d-i keyboard-configuration/xkb-keymap select br

# Clock Setup
d-i time/zone string America/Sao_Paulo
d-i clock-setup/utc boolean true
# set above to false if making a bootable USB to run on same system as Windows

# Network Setup
d-i netcfg/get_hostname string ${hostname}
d-i netcfg/get_domain string
d-i netcfg/choose_interface select auto

# User Setup
d-i passwd/user-fullname string ${ssh_fullname}
d-i passwd/username string ${ssh_username}
d-i passwd/user-password password ${ssh_password}
d-i passwd/user-password-again password ${ssh_password}
d-i user-setup/allow-password-weak boolean true
d-i user-setup/encrypt-home boolean false
d-i passwd/root-login boolean false

# Package Setup
d-i hw-detect/load_firmware boolean false
d-i hw-detect/load_media boolean false
apt-cdrom-setup apt-setup/cdrom/set-first boolean false
d-i mirror/country string manual
d-i mirror/http/hostname string deb.debian.org
d-i mirror/http/directory string /debian
d-i mirror/http/proxy string
d-i apt-setup/contrib boolean true
d-i apt-setup/non-free boolean true
tasksel tasksel/first multiselect print-server, ssh-server, standard
d-i pkgsel/include string sudo, unattended-upgrades
popularity-contest popularity-contest/participate boolean false

# Drive Setup
d-i grub-installer/only_debian boolean true
d-i grub-installer/with_other_os boolean true
d-i grub-installer/bootdev string default
d-i partman-auto/disk string /dev/sda
d-i partman-lvm/device_remove_lvm boolean true
d-i partman-md/device_remove_md boolean true
d-i partman-partitioning/confirm_write_new_label boolean true
d-i partman/choose_partition select finish
d-i partman/confirm boolean true
d-i partman/confirm_nooverwrite boolean true
d-i partman-auto/method string lvm
d-i partman-auto-lvm/new_vg_name string primary
d-i partman-auto-lvm/guided_size string max
d-i partman-lvm/confirm boolean true
d-i partman-lvm/confirm_nooverwrite boolean true
d-i partman-auto/choose_recipe select atomic

# Final Setup
d-i finish-install/reboot_in_progress note