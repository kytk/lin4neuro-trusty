#!/bin/bash

#Part3: Check if software is installed.

echo "Check if neuroimaging software is properly installed."

#AFNI
if [ ! -e ~/.afnirc ]; then
    cp /usr/local/afni/bin/AFNI.afnirc ~/.afnirc
else
    echo ".afnirc exists"
fi

if [ ! -e ~/.sumarc ]; then
    suma -update_env
else
    echo ".sumarc exists"
fi

afni_system_check.py -check_all

#Slicer
Slicer

#c3d
c3d

#ANTs
ANTS

#ITK-SNAP
itksnap

#MRIcroGL
MRIcroGL

#MRIcron
mricron

#ROBEX
ROBEX

#FSL-doc
sudo mkdir $FSLDIR/doc/redirects
echo '<meta http-equiv="refresh" content="0; url=file:///usr/share/fsl/5.0/doc/wiki/FSL.html" />' | sudo tee $FSLDIR/doc/redirects/index.html

#FSL
fsl

#FSLView
fslview

