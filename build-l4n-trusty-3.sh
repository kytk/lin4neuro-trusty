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

afni

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

#FSL
fsl

#FSLView
fslview

