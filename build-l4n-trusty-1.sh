#!/bin/bash
#Lin4Neuro making script part 1
#This script installs minimal Ubuntu with XFCE 4.12
#Prerequisite: You need to install Ubuntu 14.04 with mini.iso and git.

#ChangeLog
#19-Mar-2017: Add gcalctool
#06-Aug-2016: Move setting neurodebian repository from part 2 to part 1
#30-Jan-2016: Add default-jdk
#26-Jan-2016: Comment the download section due to the shift to github
#20-Jan-2016: Add system-config-printer-gnome
#17-Jan-2016: Add default-jre
#15-Jan-2016: Minor changes
#14-Jan-2016: Merge Engilsh version with Japanese version.
#30-Nov-2015: Modify for English version
#25-Nov-2015: Add log function

MISC_JA=""
log=`date +%Y-%m-%d`-part1.log
exec &> >(tee -a "$log")

echo "Which language do you want to build? (English/Japanese)"
select lang in "English" "Japanese" "quit"
do
  if [ $REPLY = "q" ] ; then
     echo "quit."
     exit 0
  fi
  if [ -z "$lang" ] ; then
     continue
  elif [ $lang == "Japanese" ] ; then
     MISC_JA="nkf unar"

     #Setup Neurodebian repository
     wget -O- http://neuro.debian.net/lists/trusty.jp.full | \
     sudo tee /etc/apt/sources.list.d/neurodebian.sources.list
     break

  elif [ $lang == "English" ] ; then

     #Setup Neurodebian repository
     wget -O- http://neuro.debian.net/lists/trusty.us-nh.full | \
     sudo tee /etc/apt/sources.list.d/neurodebian.sources.list
     break

  elif [ $lang == "quit" ] ; then
     echo "quit."
     exit 0
  fi
done

#Signature for neurodebian
#sudo apt-key adv --recv-keys --keyserver \
#   hkp://pgp.mit.edu:80 0xA5D32F012649A5A9
sudo apt-key add neuro.debian.net.asc
sudo apt-get update

#Installation of XFCE 4.10
LANG=C
echo "Installation of XFCE 4.10"
sudo apt-get -y install xfce4 xfce4-terminal xfce4-indicator-plugin \
	xfce4-power-manager-plugins lightdm lightdm-gtk-greeter \
	shimmer-themes network-manager-gnome xinit git \
	linux-image-hwe-generic-trusty linux-hwe-generic-trusty \
	linux-headers-generic-lts-utopic build-essential dkms \
	thunar-archive-plugin file-roller gawk default-jre default-jdk \
	system-config-printer-gnome xdg-utils

#Installation of misc packages
echo "Installation of misc packages"
sudo apt-get -y install wajig imagemagick evince gedit \
	unzip zip gparted ristretto gcalctool $MISC_JA

#Installation of libraries for neuroimaging packages
sudo apt-get -y install libjsoncpp0

#vim settings
cp /usr/share/vim/vimrc ~/.vimrc
sed -i -e 's/"set background=dark/set background=dark/' ~/.vimrc

if [ $lang == "English" ] ; then
  #English-dependent packages
  echo "Installation of firefox"
  sudo apt-get -y install firefox firefox-locale-en
else
  #Japanese-dependent environment
  echo "Installation of fcitx and firefox"
  sudo apt-get -y install fcitx fcitx-mozc firefox firefox-locale-ja
  #Change directories to English
  LANG=C xdg-user-dirs-update --force
fi

#Upgrade to XFCE 4.12
echo "Upgrade to XFCE 4.12"
sudo apt-get -y install software-properties-common
sudo add-apt-repository -y ppa:xubuntu-dev/xfce-4.12
sudo apt-get update && sudo apt-get -y dist-upgrade

#Remove xscreensaver
sudo apt-get -y purge xscreensaver

#Installation of byobu
echo "Installation of byobu"
sudo add-apt-repository -y ppa:byobu/ppa
sudo apt-get update; sudo apt-get -y install byobu

echo "Part1 Finished! The system will reboot. Please run build-l4n-trusty-2.sh."

sleep 3
sudo reboot

