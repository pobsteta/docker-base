#!/bin/bash
set -e
source /bd_build/buildconfig
set -x

## Temporarily disable dpkg fsync to make building faster.
if [[ ! -e /etc/dpkg/dpkg.cfg.d/docker-apt-speedup ]]; then
	echo force-unsafe-io > /etc/dpkg/dpkg.cfg.d/docker-apt-speedup
fi

## Prevent initramfs updates from trying to run grub and lilo.
## https://journal.paul.querna.org/articles/2013/10/15/docker-ubuntu-on-rackspace/
## http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=594189
export INITRD=no
mkdir -p /etc/container_environment
echo -n no > /etc/container_environment/INITRD

## Enable Ubuntu Universe and Multiverse.
sed -i 's/^#\s*\(deb.*universe\)$/\1/g' /etc/apt/sources.list
sed -i 's/^#\s*\(deb.*multiverse\)$/\1/g' /etc/apt/sources.list
apt-get update

## Fix some issues with APT packages.
## See https://github.com/dotcloud/docker/issues/1024
dpkg-divert --local --rename --add /sbin/initctl
ln -sf /bin/true /sbin/initctl

## Replace the 'ischroot' tool to make it always return true.
## Prevent initscripts updates from breaking /dev/shm.
## https://journal.paul.querna.org/articles/2013/10/15/docker-ubuntu-on-rackspace/
## https://bugs.launchpad.net/launchpad/+bug/974584
dpkg-divert --local --rename --add /usr/bin/ischroot
ln -sf /bin/true /usr/bin/ischroot

## Install HTTPS support for APT.
$minimal_apt_get_install apt-transport-https ca-certificates

## Install add-apt-repository
$minimal_apt_get_install software-properties-common

## Fix locale.
$minimal_apt_get_install language-pack-fr
locale-gen fr_FR
update-locale LANG=fr_FR.UTF-8 LC_CTYPE=fr_FR.UTF-8
echo -n fr_FR.UTF-8 > /etc/container_environment/LANG
echo -n fr_FR.UTF-8 > /etc/container_environment/LC_CTYPE
