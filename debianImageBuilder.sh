# Debian Image Builder
# Another in a long line of Builder scripts
# by gnarlyc
# This scrip is in the public domain. (There's really not much to it.) Thank you, and have a nice day.
echo "******************************"
echo "Setting up variables"
echo "******************************"
export image_name=linux.img	
export build_folder=linux_image
export config_name=linuxstrap.config
let "real_image_size=6442450944"
echo "******************************"
echo "Installing dependencies"
echo "******************************"
apt-get install multistrap
echo "******************************"
echo "Gather info"
echo "******************************"
echo -n "What size image would you like to create? (in GBs): "
read image_size
let "real_image_size = $image_size * 1024 * 1024 * 1024"
echo ""
echo -n "List any extra packages here: (separate them by a space) "
read extra_packages
echo "******************************"
echo "Creating image"
echo "******************************"
dd if=/dev/zero of=$image_name seek=$real_image_size bs=1 count=1
mke2fs -F $image_name
echo "******************************"
echo "Mounting image"
echo "******************************"
mkdir $build_folder
mount -o loop -t ext2 $image_name $build_folder
echo ""
echo "Buidling multistrap config file"
echo ""
echo "[General]" >> $config_name
echo "arch=armel" >> $config_name
echo "directory=/opt/multistrap/" >> $config_name
echo "cleanup=true" >> $config_name
echo "noauth=false" >> $config_name
echo "unpack=true" >> $config_name
echo "aptsources=Grip Updates" >> $config_name
echo "bootstrap=Debian" >> $config_name
echo "" >> $config_name
echo "[Debian]" >> $config_name
echo "packages=$extra_packages" >> $config_name
echo "source=http://ftp.us.debian.org/debian" >> $config_name
echo "keyring=debian-archive-keyring" >> $config_name
echo "suite=squeeze" >> $config_name
echo "******************************"
echo "Installing packages into image"
echo "******************************"
multistrap -d $build_folder/ -f $config_name
echo "******************************"
echo "Modding config files"
echo "******************************"
echo "nameserver 4.2.2.2" >> $build_folder/etc/resolv.conf
echo "nameserver 8.8.8.8" >> $build_folder/etc/resolv.conf
echo "nameserver 8.8.4.4" >> $build_folder/etc/resolv.conf
echo "export PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin" >> $build_folder/etc/bash.bashrc
echo "export TERM=linux" >> $build_folder/etc/bash.bashrc
echo "export HOME=/root" >> $build_folder/etc/bash.bashrc
echo "export USER=root" >> $build_folder/etc/bash.bashrc
echo "mount -t devpts devpts /dev/pts" >> $build_folder/etc/bash.bashrc
echo "mount -t proc proc /proc" >> $build_folder/etc/bash.bashrc
echo "mount -t sysfs sysfs /sys" >> $build_folder/etc/bash.bashrc
echo "127.0.0.1	locahost" >> $build_folder/etc/hosts
echo "******************************"
echo "Unmounting image"
echo "******************************"
umount $build_folder/
echo "You will still need to copy the image to your phone, of course."
echo "After that..."
echo "1) Use a terminal emulator (i.e. Connectbot) and 'su'"
echo "2) mkdir /data/local/linux (or something similar)"
echo "3) mount -o loop -t ext2 /sdcard/$image_name /data/local/linux"
echo "4) chroot /data/local/linux /bin/bash"
echo "5) add 'deb http://ftp.us.debian.org/debian squeeze main' to /etc/apt/sources.list"
echo "6) apt-get update && apt-get upgrade"
echo "******************************"
echo "Of course, I would script as much of that as possible..."
echo "You'll only need #3 and #4 for daily use after the others are done."
