#!/bin/sh

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

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

yay -S - < aurlist

#add user
read -p 'Select username: ' USERNAME
useradd -m -g users -G wheel,audio,games,network,disk,storage,video -s /bin/zsh $USERNAME
passwd $USERNAME

#visudo
export EDITOR=vim visudo
