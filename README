wrqs@first-vm:~/ubuntu_v$ vagrant ssh # Подключение к машине
Welcome to Ubuntu 16.04.7 LTS (GNU/Linux 4.4.0-210-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

UA Infra: Extended Security Maintenance (ESM) is not enabled.

0 updates can be applied immediately.

45 additional security updates can be applied with UA Infra: ESM
Learn more about enabling UA Infra: ESM service for Ubuntu 16.04 at
https://ubuntu.com/16-04

New release '18.04.6 LTS' available.
Run 'do-release-upgrade' to upgrade to it.


vagrant@ubuntu-xenial:~$ uname -r # Вывод версии ядра
4.4.0-210-generic
vagrant@ubuntu-xenial:~$ sudo apt update # Проверка доступных обновлений
Hit:1 http://archive.ubuntu.com/ubuntu xenial InRelease
Get:2 http://archive.ubuntu.com/ubuntu xenial-updates InRelease [106 kB]
Get:3 http://security.ubuntu.com/ubuntu xenial-security InRelease [106 kB]
Get:4 https://esm.ubuntu.com/infra/ubuntu xenial-infra-security InRelease [7,524 B]
Get:5 https://esm.ubuntu.com/infra/ubuntu xenial-infra-updates InRelease [7,472 B]
Get:6 http://archive.ubuntu.com/ubuntu xenial-backports InRelease [106 kB]
Get:7 http://archive.ubuntu.com/ubuntu xenial/universe amd64 Packages [7,532 kB]
Get:8 https://esm.ubuntu.com/infra/ubuntu xenial-infra-security/main amd64 Packages [1,045 kB]
Get:9 http://archive.ubuntu.com/ubuntu xenial/universe Translation-en [4,354 kB]
Get:10 http://security.ubuntu.com/ubuntu xenial-security/main amd64 Packages [913 kB]
Get:11 http://archive.ubuntu.com/ubuntu xenial/multiverse amd64 Packages [144 kB]
Get:12 http://archive.ubuntu.com/ubuntu xenial/multiverse Translation-en [106 kB]
Get:13 https://esm.ubuntu.com/infra/ubuntu xenial-infra-updates/main amd64 Packages [4,980 B]
Get:14 http://archive.ubuntu.com/ubuntu xenial-updates/main amd64 Packages [1,269 kB]
Get:15 http://archive.ubuntu.com/ubuntu xenial-updates/main Translation-en [303 kB]
Get:16 http://archive.ubuntu.com/ubuntu xenial-updates/universe amd64 Packages [1,171 kB]
Get:17 http://archive.ubuntu.com/ubuntu xenial-updates/universe Translation-en [334 kB]
Get:18 http://archive.ubuntu.com/ubuntu xenial-updates/multiverse amd64 Packages [21.6 kB]
Get:19 http://archive.ubuntu.com/ubuntu xenial-updates/multiverse Translation-en [8,440 B]
Get:20 http://archive.ubuntu.com/ubuntu xenial-backports/main amd64 Packages [10.2 kB]
Get:21 http://archive.ubuntu.com/ubuntu xenial-backports/main Translation-en [4,456 B]
Get:22 http://archive.ubuntu.com/ubuntu xenial-backports/universe amd64 Packages [11.5 kB]
Get:23 http://archive.ubuntu.com/ubuntu xenial-backports/universe Translation-en [4,476 B]
Get:24 http://security.ubuntu.com/ubuntu xenial-security/main Translation-en [211 kB]
Get:25 http://security.ubuntu.com/ubuntu xenial-security/universe amd64 Packages [740 kB]
Get:26 http://security.ubuntu.com/ubuntu xenial-security/universe Translation-en [203 kB]
Get:27 http://security.ubuntu.com/ubuntu xenial-security/multiverse amd64 Packages [7,864 B]
Get:28 http://security.ubuntu.com/ubuntu xenial-security/multiverse Translation-en [2,672 B]
Fetched 18.7 MB in 4s (4,246 kB/s)
Reading package lists... Done
Building dependency tree
Reading state information... Done
14 packages can be upgraded. Run 'apt list --upgradable' to see them.
vagrant@ubuntu-xenial:~$ sudo apt list --upgradable
Listing... Done
apparmor/xenial-updates,xenial-security 2.10.95-0ubuntu2.12 amd64 [upgradable from: 2.10.95-0ubuntu2.11]
base-files/xenial-updates 9.4ubuntu4.14 amd64 [upgradable from: 9.4ubuntu4.13]
distro-info/xenial-updates 0.14ubuntu0.3 amd64 [upgradable from: 0.14ubuntu0.2]
distro-info-data/xenial-updates,xenial-security,xenial-infra-security 0.28ubuntu0.19 all [upgradable from: 0.28ubuntu0.18]
libapparmor-perl/xenial-updates,xenial-security 2.10.95-0ubuntu2.12 amd64 [upgradable from: 2.10.95-0ubuntu2.11]
libapparmor1/xenial-updates,xenial-security 2.10.95-0ubuntu2.12 amd64 [upgradable from: 2.10.95-0ubuntu2.11]
motd-news-config/xenial-updates 9.4ubuntu4.14 all [upgradable from: 9.4ubuntu4.13]
python3-distro-info/xenial-updates 0.14ubuntu0.3 all [upgradable from: 0.14ubuntu0.2]
python3-software-properties/xenial-updates 0.96.20.13 all [upgradable from: 0.96.20.10]
python3-update-manager/xenial-updates 1:16.04.23 all [upgradable from: 1:16.04.17]
software-properties-common/xenial-updates 0.96.20.13 all [upgradable from: 0.96.20.10]
ubuntu-advantage-tools/xenial-updates 34~16.04 amd64 [upgradable from: 27.2.2~16.04.1]
update-manager-core/xenial-updates 1:16.04.23 all [upgradable from: 1:16.04.17]
update-notifier-common/xenial-updates 3.168.22 all [upgradable from: 3.168.15]
vagrant@ubuntu-xenial:~$ apt install --install-recommends linux-generic-hwe-16.04
E: Could not open lock file /var/lib/dpkg/lock-frontend - open (13: Permission denied)
E: Unable to acquire the dpkg frontend lock (/var/lib/dpkg/lock-frontend), are you root?
vagrant@ubuntu-xenial:~$ sudo apt install --install-recommends linux-generic-hwe-16.04 # Установка рекомендованного ядра для этой версии ОС
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following additional packages will be installed:
  amd64-microcode crda intel-microcode iucode-tool iw libnl-3-200 libnl-genl-3-200 linux-firmware
  linux-headers-4.15.0-142 linux-headers-4.15.0-142-generic linux-headers-generic-hwe-16.04
  linux-image-4.15.0-142-generic linux-image-generic-hwe-16.04 linux-modules-4.15.0-142-generic
  linux-modules-extra-4.15.0-142-generic thermald wireless-regdb
Suggested packages:
  fdutils linux-hwe-tools
The following NEW packages will be installed:
  amd64-microcode crda intel-microcode iucode-tool iw libnl-3-200 libnl-genl-3-200 linux-firmware
  linux-generic-hwe-16.04 linux-headers-4.15.0-142 linux-headers-4.15.0-142-generic linux-headers-generic-hwe-16.04
  linux-image-4.15.0-142-generic linux-image-generic-hwe-16.04 linux-modules-4.15.0-142-generic
  linux-modules-extra-4.15.0-142-generic thermald wireless-regdb
0 upgraded, 18 newly installed, 0 to remove and 14 not upgraded.
Need to get 120 MB of archives.
After this operation, 579 MB of additional disk space will be used.
Do you want to continue? [Y/n] y
Get:1 http://archive.ubuntu.com/ubuntu xenial-updates/main amd64 libnl-3-200 amd64 3.2.27-1ubuntu0.16.04.1 [52.2 kB]
Get:2 http://archive.ubuntu.com/ubuntu xenial-updates/main amd64 libnl-genl-3-200 amd64 3.2.27-1ubuntu0.16.04.1 [11.2 kB]
Get:3 http://archive.ubuntu.com/ubuntu xenial-updates/main amd64 wireless-regdb all 2024.07.04-0ubuntu1~16.04.1 [9,948 B]
Get:4 http://archive.ubuntu.com/ubuntu xenial/main amd64 iw amd64 3.17-1 [63.5 kB]
Get:5 http://archive.ubuntu.com/ubuntu xenial/main amd64 crda amd64 3.13-1 [60.5 kB]
Get:6 http://archive.ubuntu.com/ubuntu xenial-updates/main amd64 iucode-tool amd64 1.5.1-1ubuntu0.1 [33.8 kB]
Get:7 http://archive.ubuntu.com/ubuntu xenial-updates/main amd64 linux-firmware all 1.157.23 [50.6 MB]
Get:8 http://archive.ubuntu.com/ubuntu xenial-updates/main amd64 linux-modules-4.15.0-142-generic amd64 4.15.0-142.146~16.04.1 [13.1 MB]
Get:9 http://archive.ubuntu.com/ubuntu xenial-updates/main amd64 linux-image-4.15.0-142-generic amd64 4.15.0-142.146~16.04.1 [8,014 kB]
Get:10 http://archive.ubuntu.com/ubuntu xenial-updates/main amd64 linux-modules-extra-4.15.0-142-generic amd64 4.15.0-142.146~16.04.1 [32.9 MB]
Get:11 http://archive.ubuntu.com/ubuntu xenial-updates/main amd64 intel-microcode amd64 3.20210216.0ubuntu0.16.04.1 [2,747 kB]
Get:12 http://archive.ubuntu.com/ubuntu xenial-updates/main amd64 amd64-microcode amd64 3.20191021.1+really3.20180524.1~ubuntu0.16.04.2 [30.8 kB]
Get:13 http://archive.ubuntu.com/ubuntu xenial-updates/main amd64 linux-image-generic-hwe-16.04 amd64 4.15.0.142.137 [2,410 B]
Get:14 http://archive.ubuntu.com/ubuntu xenial-updates/main amd64 linux-headers-4.15.0-142 all 4.15.0-142.146~16.04.1 [10.9 MB]
Get:15 http://archive.ubuntu.com/ubuntu xenial-updates/main amd64 linux-headers-4.15.0-142-generic amd64 4.15.0-142.146~16.04.1 [1,098 kB]
Get:16 http://archive.ubuntu.com/ubuntu xenial-updates/main amd64 linux-headers-generic-hwe-16.04 amd64 4.15.0.142.137 [2,356 B]
Get:17 http://archive.ubuntu.com/ubuntu xenial-updates/main amd64 linux-generic-hwe-16.04 amd64 4.15.0.142.137 [1,804 B]
Get:18 http://archive.ubuntu.com/ubuntu xenial-updates/main amd64 thermald amd64 1.5-2ubuntu4 [187 kB]
Fetched 120 MB in 16s (7,379 kB/s)
Selecting previously unselected package libnl-3-200:amd64.
(Reading database ... 54424 files and directories currently installed.)
Preparing to unpack .../libnl-3-200_3.2.27-1ubuntu0.16.04.1_amd64.deb ...
Unpacking libnl-3-200:amd64 (3.2.27-1ubuntu0.16.04.1) ...
Selecting previously unselected package libnl-genl-3-200:amd64.
Preparing to unpack .../libnl-genl-3-200_3.2.27-1ubuntu0.16.04.1_amd64.deb ...
Unpacking libnl-genl-3-200:amd64 (3.2.27-1ubuntu0.16.04.1) ...
Selecting previously unselected package wireless-regdb.
Preparing to unpack .../wireless-regdb_2024.07.04-0ubuntu1~16.04.1_all.deb ...
Unpacking wireless-regdb (2024.07.04-0ubuntu1~16.04.1) ...
Selecting previously unselected package iw.
Preparing to unpack .../archives/iw_3.17-1_amd64.deb ...
Unpacking iw (3.17-1) ...
Selecting previously unselected package crda.
Preparing to unpack .../archives/crda_3.13-1_amd64.deb ...
Unpacking crda (3.13-1) ...
Selecting previously unselected package iucode-tool.
Preparing to unpack .../iucode-tool_1.5.1-1ubuntu0.1_amd64.deb ...
Unpacking iucode-tool (1.5.1-1ubuntu0.1) ...
Selecting previously unselected package linux-firmware.
Preparing to unpack .../linux-firmware_1.157.23_all.deb ...
Unpacking linux-firmware (1.157.23) ...
Selecting previously unselected package linux-modules-4.15.0-142-generic.
Preparing to unpack .../linux-modules-4.15.0-142-generic_4.15.0-142.146~16.04.1_amd64.deb ...
Unpacking linux-modules-4.15.0-142-generic (4.15.0-142.146~16.04.1) ...
Selecting previously unselected package linux-image-4.15.0-142-generic.
Preparing to unpack .../linux-image-4.15.0-142-generic_4.15.0-142.146~16.04.1_amd64.deb ...
Unpacking linux-image-4.15.0-142-generic (4.15.0-142.146~16.04.1) ...
Selecting previously unselected package linux-modules-extra-4.15.0-142-generic.
Preparing to unpack .../linux-modules-extra-4.15.0-142-generic_4.15.0-142.146~16.04.1_amd64.deb ...
Unpacking linux-modules-extra-4.15.0-142-generic (4.15.0-142.146~16.04.1) ...
Selecting previously unselected package intel-microcode.
Preparing to unpack .../intel-microcode_3.20210216.0ubuntu0.16.04.1_amd64.deb ...
Unpacking intel-microcode (3.20210216.0ubuntu0.16.04.1) ...
Selecting previously unselected package amd64-microcode.
Preparing to unpack .../amd64-microcode_3.20191021.1+really3.20180524.1~ubuntu0.16.04.2_amd64.deb ...
Unpacking amd64-microcode (3.20191021.1+really3.20180524.1~ubuntu0.16.04.2) ...
Selecting previously unselected package linux-image-generic-hwe-16.04.
Preparing to unpack .../linux-image-generic-hwe-16.04_4.15.0.142.137_amd64.deb ...
Unpacking linux-image-generic-hwe-16.04 (4.15.0.142.137) ...
Selecting previously unselected package linux-headers-4.15.0-142.
Preparing to unpack .../linux-headers-4.15.0-142_4.15.0-142.146~16.04.1_all.deb ...
Unpacking linux-headers-4.15.0-142 (4.15.0-142.146~16.04.1) ...
Selecting previously unselected package linux-headers-4.15.0-142-generic.
Preparing to unpack .../linux-headers-4.15.0-142-generic_4.15.0-142.146~16.04.1_amd64.deb ...
Unpacking linux-headers-4.15.0-142-generic (4.15.0-142.146~16.04.1) ...
Selecting previously unselected package linux-headers-generic-hwe-16.04.
Preparing to unpack .../linux-headers-generic-hwe-16.04_4.15.0.142.137_amd64.deb ...
Unpacking linux-headers-generic-hwe-16.04 (4.15.0.142.137) ...
Selecting previously unselected package linux-generic-hwe-16.04.
Preparing to unpack .../linux-generic-hwe-16.04_4.15.0.142.137_amd64.deb ...
Unpacking linux-generic-hwe-16.04 (4.15.0.142.137) ...
Selecting previously unselected package thermald.
Preparing to unpack .../thermald_1.5-2ubuntu4_amd64.deb ...
Unpacking thermald (1.5-2ubuntu4) ...
Processing triggers for libc-bin (2.23-0ubuntu11.3) ...
Processing triggers for man-db (2.7.5-1) ...
Processing triggers for dbus (1.10.6-1ubuntu3.6) ...
Processing triggers for ureadahead (0.100.0-19.1) ...
Processing triggers for systemd (229-4ubuntu21.31) ...
Setting up libnl-3-200:amd64 (3.2.27-1ubuntu0.16.04.1) ...
Setting up libnl-genl-3-200:amd64 (3.2.27-1ubuntu0.16.04.1) ...
Setting up wireless-regdb (2024.07.04-0ubuntu1~16.04.1) ...
Setting up iw (3.17-1) ...
Setting up crda (3.13-1) ...
Setting up iucode-tool (1.5.1-1ubuntu0.1) ...
Setting up linux-firmware (1.157.23) ...
update-initramfs: Generating /boot/initrd.img-4.4.0-210-generic
W: mdadm: /etc/mdadm/mdadm.conf defines no arrays.
Setting up linux-modules-4.15.0-142-generic (4.15.0-142.146~16.04.1) ...
Setting up linux-image-4.15.0-142-generic (4.15.0-142.146~16.04.1) ...
I: /vmlinuz is now a symlink to boot/vmlinuz-4.15.0-142-generic
I: /initrd.img is now a symlink to boot/initrd.img-4.15.0-142-generic
Setting up linux-modules-extra-4.15.0-142-generic (4.15.0-142.146~16.04.1) ...
Setting up intel-microcode (3.20210216.0ubuntu0.16.04.1) ...
update-initramfs: deferring update (trigger activated)
intel-microcode: microcode will be updated at next boot
Setting up amd64-microcode (3.20191021.1+really3.20180524.1~ubuntu0.16.04.2) ...
update-initramfs: deferring update (trigger activated)
amd64-microcode: microcode will be updated at next boot
Setting up linux-image-generic-hwe-16.04 (4.15.0.142.137) ...
Setting up linux-headers-4.15.0-142 (4.15.0-142.146~16.04.1) ...
Setting up linux-headers-4.15.0-142-generic (4.15.0-142.146~16.04.1) ...
Setting up linux-headers-generic-hwe-16.04 (4.15.0.142.137) ...
Setting up linux-generic-hwe-16.04 (4.15.0.142.137) ...
Setting up thermald (1.5-2ubuntu4) ...
Processing triggers for libc-bin (2.23-0ubuntu11.3) ...
Processing triggers for linux-image-4.15.0-142-generic (4.15.0-142.146~16.04.1) ...
/etc/kernel/postinst.d/initramfs-tools:
update-initramfs: Generating /boot/initrd.img-4.15.0-142-generic
W: mdadm: /etc/mdadm/mdadm.conf defines no arrays.
/etc/kernel/postinst.d/x-grub-legacy-ec2:
Searching for GRUB installation directory ... found: /boot/grub
Searching for default file ... found: /boot/grub/default
Testing for an existing GRUB menu.lst file ... found: /boot/grub/menu.lst
Searching for splash image ... none found, skipping ...
Found kernel: /boot/vmlinuz-4.4.0-210-generic
Found kernel: /boot/vmlinuz-4.15.0-142-generic
Found kernel: /boot/vmlinuz-4.4.0-210-generic
Replacing config file /run/grub/menu.lst with new version
Updating /boot/grub/menu.lst ... done

/etc/kernel/postinst.d/zz-update-grub:
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-4.15.0-142-generic
Found initrd image: /boot/initrd.img-4.15.0-142-generic
Found linux image: /boot/vmlinuz-4.4.0-210-generic
Found initrd image: /boot/initrd.img-4.4.0-210-generic
done
Processing triggers for initramfs-tools (0.122ubuntu8.17) ...
update-initramfs: Generating /boot/initrd.img-4.15.0-142-generic
W: mdadm: /etc/mdadm/mdadm.conf defines no arrays.
Processing triggers for dbus (1.10.6-1ubuntu3.6) ...
Processing triggers for ureadahead (0.100.0-19.1) ...
Processing triggers for systemd (229-4ubuntu21.31) ...
vagrant@ubuntu-xenial:~$ sudo reboot # Перезагрузка
Connection to 127.0.0.1 closed by remote host.
wrqs@first-vm:~/ubuntu_v$ vagrant ssh # Повторное подключение
Welcome to Ubuntu 16.04.7 LTS (GNU/Linux 4.15.0-142-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

10 updates can be applied immediately.
5 of these updates are standard security updates.
To see these additional updates run: apt list --upgradable

New release '18.04.6 LTS' available.
Run 'do-release-upgrade' to upgrade to it.


Last login: Wed Jan 29 08:38:02 2025 from 10.0.2.2
vagrant@ubuntu-xenial:~$ uname -r # Вывод информации о версии ядра
4.15.0-142-generic # Ядро обновлено
