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

#timezone
echo "Set timezone to Argentina/Buenos_Aires. y/n?"
while :
do
read INPUT_STRING

  case $INPUT_STRING in
	y)
		echo "Setting..."
		ln -sf /usr/share/zoneinfo/America/Argentina/Buenos_Aires /etc/localtime
		hwclock --systohc
		echo "Done!"
		break
		;;
	n)
		echo "Aborting..."
		break
		;;
	*)
		echo "Set timezone to Argentina/Buenos_Aires. y/n?"
		;;
  esac
done

#locales
echo "Set locale. en_US-UTF-8. y/n?"
while :
do
read INPUT_STRING

  case $INPUT_STRING in
	y)
		echo "Setting..."
		echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
		locale-gen
		echo "LANG=en_US.UTF-8" >> /etc/locale.conf
		echo "Done!"
		break
		;;
	n)
		echo "Aborting..."
		break
		;;
	*)
		echo "Set locale. en_US-UTF-8. y/n?"
		;;
  esac
done

#network
echo "Config hostname and network?. y/n?"
while :
do
read INPUT_STRING

  case $INPUT_STRING in
	y)
		read -p 'Hostname: ' HOSTNAME
		echo $HOSTNAME >> /etc/hostname
		echo "127.0.0.1	localhost" >> /etc/hosts
		echo "::1		localhost" >> /etc/hosts
		echo "Done!"
		break
		;;
	n)
		echo "Aborting..."
		break
		;;
	*)
		echo "Config hostname and network?. y/n?"
		;;
  esac
done
echo "Wired dhcp?. y/n?"
while :
do
read INPUT_STRING

  case $INPUT_STRING in
	y)
		echo "Setting..."
		cp /etc/netctl/examples/ethernet-dhcp /etc/netctl/wired
		sed -i 'Ns/.*/Interface=eno1/' /etc/netctl/wired 
		echo "Done!"
		break
		;;
	n)
		echo "Aborting..."
		break
		;;
	*)
		echo "Wired dhcp?. y/n?"
		;;
  esac
done

#bootloader
echo "Install bootloader?. y/n?"
while :
do
read INPUT_STRING

  case $INPUT_STRING in
	y)
		echo "Installing..."
		efibootmgr --disk /dev/sda --part 1 --create --label "Arch Linux" --loader /vmlinuz-linux --unicode 'root=/dev/sda2 rw initrd=/intel-ucode.img initrd=\initramfs-linux.img' --verbose
		echo "Done!"
		break
		;;
	n)
		echo "Aborting..."
		break
		;;
	*)
		echo "Install bootloader?. y/n?"
		;;
  esac
done
#root password 
echo "Setting root passwd"
passwd 

#packages 
echo "Installing packages"
pacman -S - < pkglist
 

#aur packages

git clone https://aur.archlinux.org/dunstify.git
cd dunstify
makepkg -si

git clone https://aur.archlinux.org/lightdm-slick-greeter.git
cd lightdm-slick-greeter
makepkg -si

git clone https://aur.archlinux.org/pakku.git
cd pakku
makepkg -si

git clone https://aur.archlinux.org/polybar-git.git
cd polybar-git
makepkg -si

git clone https://aur.archlinux.org/sensei-raw-ctl-git.git
cd sensei-raw-ctl-git
makepkg -si

git clone https://aur.archlinux.org/siji-git.git
cd siji-git
makepkg -si

git clone https://aur.archlinux.org/trizen.git
cd trizen
makepkg -si

git clone https://aur.archlinux.org/i3lock-fancy-git.git
cd i3lock-fancy-git
makepkg -si

#add user
read -p 'Select username: ' USERNAME
useradd -m -g users -G wheel,audio,games,network,disk,storage,video -s /bin/zsh $USERNAME
passwd $USERNAME

#visudo
export EDITOR=vim visudo