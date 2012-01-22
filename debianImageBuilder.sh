# Debian Image Builder
# Another in a long line of Builder scripts
# by gnarlyc
# This scrip is in the public domain. (There's really not much to it.) Thank you, and have a nice day.
echo "******************************"
echo "Setting up variables"
echo "******************************"
export image_name=debian.img	
export build_folder=image_folder
let "real_image_size=6442450944"
echo "******************************"
echo "Installing dependencies"
echo "******************************"
apt-get install debootstrap
echo "******************************"
echo "Gather info"
echo "******************************"
echo -n "What size image would you like to create? (in GBs): "
read image_size
let "real_image_size = $image_size * 1024 * 1024 * 1024"
echo ""
echo -n "List any extra packages here: (separate them by a comma) "
read extra_packages
read -p "ENTER"
echo "******************************"
echo "Creating image"
echo "******************************"
dd if=/dev/zero of=$image_name seek=$real_image_size bs=1 count=1
mke2fs -F $image_name
read -p "ENTER"
echo "******************************"
echo "Mounting image"
echo "******************************"
mkdir $build_folder
mount -o loop -t ext2 $image_name $build_folder
echo "******************************"
echo "Installing packages into image"
echo "******************************"
debootstrap --verbose --foreign --include=$extra_packages --arch armel squeeze $build_folder http://ftp.us.debian.org/debian
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
cp setup.sh $build_folder/
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
echo "5) run 'setup.sh' once to finsih debootstrap, fix your repo, and update the install"
echo "******************************"
echo "Of course, I would script as much of that as possible..."
echo "You'll only need #3 and #4 for daily use after the others are done."
