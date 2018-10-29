#!/bin/sh

# 20180916
# This script seeks to automitize some tasks in my Arch Linux installations. 
# Based on the Installation Guide (https://wiki.archlinux.org/index.php/installation_guide)
# 
# Starts after installation

#Installing required files
echo "Install deps? y/n?"
while :
do
read INPUT_STRING

  case $INPUT_STRING in
	y)
		pacman -S vim efibootmgr intel-ucode
		echo "Done!"
		break
		;;
	n)
		echo "Aborting..."
		break
		;;
	*)
		echo "Install deps? y/n?"
		;;
  esac
done

# /etc/fstab
echo "Generate /etc/fstab? y/n?"
while :
do
read INPUT_STRING

  case $INPUT_STRING in
	y)
		echo "Generating /etc/fstab"
		genfstab -U /mnt >> /mnt/etc/fstab
		echo "Done!"
		break
		;;
	n)
		echo "Aborting..."
		break
		;;
	*)
		echo "Generate /etc/fstab? y/n?"
		;;
  esac
done

#chroot
echo "Let's chroot. y/n?"
while :
do
read INPUT_STRING

  case $INPUT_STRING in
	y)
		echo "Chrooting.."
		mkdir /mnt/tmp/install
		cp post-chroot.sh /mnt/tmp/install/post-chroot.sh
		cp pkglist.sh /mnt/tmp/install/pkglist
		cp aurlist.sh /mnt/tmp/install/aurlist
		arch-chroot /mnt
		echo "Done!"
		break
		;;
	n)
		echo "Aborting..."
		break
		;;
	*)
		echo "Let's chroot. y/n?"
		;;
  esac
done
