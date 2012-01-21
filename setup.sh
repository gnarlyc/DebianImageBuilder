/debootstrap/debootstrap --second-stage
echo "deb http://ftp.us.debian.org/debian squeeze main" >> /etc/apt/sources.list
apt-get update && apt-get upgrade
