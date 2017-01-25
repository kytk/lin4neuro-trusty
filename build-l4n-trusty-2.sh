#!/bin/bash
#Lin4Neuro making script part 2
#Customize UI into Lin4Neuro
#Prerequisite: You need to finish the build-l4n-part1.sh first.

#ChangeLog
#06-Aug-2016: Move setting neurodebian repository to Part 1
#14-Jan-2016: Merge Engilsh version with Japanese version
#30-Nov-2015: Modify for English version
#25-Nov-2015: Add log function
#26-Nov-2015: Modify panel customization

log=`date +%Y-%m-%d`-part2.log
exec &> >(tee -a "$log")

#Setting of path of the setting scripts
base_path=~/git/lin4neuro-trusty/lin4neuro-parts

#Installation of lin4neuro-logo
echo "Installation of lin4neuro-logo"
sleep 1
sudo cp -r ${base_path}/lin4neuro-logo /lib/plymouth/themes
sudo update-alternatives --install /lib/plymouth/themes/default.plymouth \
	default.plymouth /lib/plymouth/themes/lin4neuro-logo/lin4neuro-logo.plymouth 100
sudo update-initramfs -u

#Installation of icons
echo "Installation of icons"
mkdir ~/.icons
cp ${base_path}/icons/* ~/.icons

#Installation of customized menu
echo "Installation of customized menu"
mkdir -p ~/.config/menus
cp ${base_path}/config/menus/xfce-applications.menu ~/.config/menus

#Installation of .desktop files
echo "Installation of .desktop files"
mkdir -p ~/.local/share/applications
cp ${base_path}/local/share/applications/* ~/.local/share/applications

#Installation of Neuroimaging.directory
echo "Installation of Neuroimaging.directory"
mkdir -p ~/.local/share/desktop-directories
cp ${base_path}/local/share/desktop-directories/Neuroimaging.directory ~/.local/share/desktop-directories

#Copy background image
echo "Copy background image"
sudo cp ${base_path}/backgrounds/deep_ocean.png /usr/share/backgrounds

#Remove system background image
sudo rm /usr/share/backgrounds/xfce/xfce-teal.jpg

#Copy modified lightdm-gtk-greeter.conf
echo "Copy modified lightdm-gtk-greeter.conf"
sudo cp ${base_path}/lightdm/lightdm-gtk-greeter-ubuntu.conf /etc/lightdm

#Settings for auto-login
echo "Settings for auto-login"
sudo mkdir -p /etc/lightdm/lightdm.conf.d
sudo cp ${base_path}/lightdm/10-ubuntu.conf /etc/lightdm/lightdm.conf.d

#Customize panel 
echo "Customize panel"
cp ${base_path}/config/xfce-perchannel-xml/xfce4-panel.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/

cp -r ${base_path}/config/panel ~/.config/xfce4/

#Customize desktop
echo "Customize desktop"
cp ${base_path}/config/xfce-perchannel-xml/xfce4-desktop.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/

#Customize theme (Greybird)
echo "Customize theme (Greybird)"
cp ${base_path}/config/xfce-perchannel-xml/xfwm4.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/

#Virtualbox guest addition
sudo apt-get -y install virtualbox-guest-dkms

#Enable virtualbox shared folder
sudo usermod -aG vboxsf $USER

#Clean packages
sudo apt-get -y autoremove

#Installation of FSL
echo "Installation of FSL"
sudo apt-get -y install fsl fsl-5.0-doc-wiki*

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
#wget https://afni.nimh.nih.gov/pub/dist/bin/linux_fedora_21_64/@update.afni.binaries

#Install AFNI
#sudo mkdir /usr/local/AFNI
#sudo ./@update.afni.binaries -package linux_openmp_64 -bindir /usr/local/AFNI

#Install prerequisite packages for DSI Studio
sudo apt-get install -y libboost-thread1.54.0 libboost-program-options1.54.0 qt5-default
sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
sudo apt-get update; sudo apt-get dist-upgrade

#Copy bashcom.sh for c3d to ~/bin
cp -r ${base_path}/bin $HOME

#Add PATH settings to .bashrc
cat ${base_path}/bashrc/bashrc-addition.txt >> $HOME/.bashrc

echo "Part 2 finished! The system will reboot to reflect the customization."
echo "Please install several packages later."
sleep 3
sudo reboot

