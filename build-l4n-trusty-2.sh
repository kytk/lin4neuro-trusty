#!/bin/bash
#Lin4Neuro making script part 2
#Customize UI into Lin4Neuro
#Prerequisite: You need to finish the build-l4n-part1.sh first.

#ChangeLog
#14-Jan-2016: Merge Engilsh version with Japanese version.
#30-Nov-2015: Modify for English version
#25-Nov-2015: Add log function
#26-Nov-2015: Modify panel customization

log=`date +%Y-%m-%d`-part2.log
exec &> >(tee -a "$log")

#Delete directories with Japanese names
if [ -e ./.lin4neuro_ja ] ; then
  cd
  if [ -e ドキュメント ]; then
        rm -r [!a-zA-Z0-9]*
  fi
fi

#Variable set
if [ -e ./.lin4neuro_en ] ; then
  full_url="http://neuro.debian.net/lists/trusty.us-nh.full"
  rm ./.lin4neuro_en 
elif [ -e ./.lin4neuro_ja ] ; then
  full_url="http://neuro.debian.net/lists/trusty.jp.full"
  rm ./.lin4neuro_ja
fi

#Download necessary files for Lin4Neuro customization
#echo "Download necessary files for customization"
#wget http://www.nemotos.net/lin4neuro/build/lin4neuro-parts.zip
#unzip ~/lin4neuro-parts.zip

#Installation of lin4neuro-logo
echo "Installation of lin4neuro-logo"
cd lin4neuro-parts
sudo mv lin4neuro-logo /lib/plymouth/themes
sudo update-alternatives --install /lib/plymouth/themes/default.plymouth \
	default.plymouth /lib/plymouth/themes/lin4neuro-logo/lin4neuro-logo.plymouth 100
sudo update-initramfs -u
cd ..

#Installation of icons
echo "Installation of icons"
mkdir ~/.icons
cp ./lin4neuro-parts/icons/* ~/.icons

#Installation of customized menu
echo "Installation of customized menu"
mkdir -p ~/.config/menus
cp ./lin4neuro-parts/config/menus/xfce-applications.menu ~/.config/menus

#Installation of .desktop files
echo "Installation of .desktop files"
mkdir -p ~/.local/share/applications
cp ./lin4neuro-parts/local/share/applications/* ~/.local/share/applications

#Installation of Neuroimaging.directory
echo "Installation of Neuroimaging.directory"
mkdir -p ~/.local/share/desktop-directories
cp ./lin4neuro-parts/local/share/desktop-directories/Neuroimaging.directory ~/.local/share/desktop-directories

#Copy background image
echo "Copy background image"
sudo cp ./lin4neuro-parts/backgrounds/deep_ocean.png /usr/share/backgrounds

#Copy modified lightdm-gtk-greeter.conf
echo "Copy modified lightdm-gtk-greeter.conf"
sudo cp ./lin4neuro-parts/lightdm/lightdm-gtk-greeter-ubuntu.conf /etc/lightdm

#Settings for auto-login
echo "Settings for auto-login"
sudo mkdir -p /etc/lightdm/lightdm.conf.d
sudo cp ./lin4neuro-parts/lightdm/10-ubuntu.conf /etc/lightdm/lightdm.conf.d

#Customize panel 
echo "Customize panel"
cp ./lin4neuro-parts/config/xfce-perchannel-xml/xfce4-panel.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/

cp -r ./lin4neuro-parts/config/panel ~/.config/xfce4/

#Customize desktop
echo "Customize desktop"
cp ./lin4neuro-parts/config/xfce-perchannel-xml/xfce4-desktop.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/

#Customize theme (Greybird)
echo "Customize theme (Greybird)"
cp ./lin4neuro-parts/config/xfce-perchannel-xml/xfwm4.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/

#Clean packages
sudo apt-get -y autoremove

#Setting up Neurodebian repository
echo "Setting up Neurodebian repository"
wget -O- $full_url | \
sudo tee /etc/apt/sources.list.d/neurodebian.sources.list
sudo apt-key adv --recv-keys --keyserver hkp://pgp.mit.edu:80 0xA5D32F012649A5A9
sudo apt-get update

#Installation of FSL
echo "Installation of FSL"
sudo apt-get -y install fsl

#PATH settings
cat << FIN >> ~/.bashrc

#FSL
. /etc/fsl/fsl.sh

FIN

#Install MRIConvert
sudo apt-get install -y mriconvert

#Install prerequisite packages for AFNI
#https://afni.nimh.nih.gov/pub/dist/doc/htmldoc/background_install/install_instructs/steps_linux_ubuntu.html#install-steps-linux-ubuntu
sudo apt-get install -y tcsh libxp6 xfonts-base python-qt4             \
                        libmotif4 libmotif-dev motif-clients           \
                        gsl-bin netpbm gnome-tweak-tool libjpeg62

#Download AFNI installation script
wget https://afni.nimh.nih.gov/pub/dist/bin/linux_fedora_21_64/@update.afni.binaries

#Install AFNI
sudo mkdir /usr/local/AFNI
sudo ./@update.afni.binaries -package linux_openmp_64 -bindir /usr/local/AFNI

#Install prerequisite packages for DSI Studio
sudo apt-get install -y libboost-thread1.54.0 libboost-program-options1.54.0 qt5-default

echo "Part 2 finished! Please reboot to reflect the customization."
