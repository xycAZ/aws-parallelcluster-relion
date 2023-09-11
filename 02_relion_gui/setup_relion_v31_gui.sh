#!/bin/bash -xue
sudo apt-get update
sudo apt-get install cmake git build-essential mpi-default-bin mpi-default-dev libfftw3-dev libtiff-dev libpng-dev ghostscript libxft-dev -y
sudo apt-get install libx11-dev libxft-dev -y

BASE_DIR=/shared
TARGET=relion-v4
RELION_TAG=master
BUILD_DIR=relion-gui

cd ${BASE_DIR}
git clone https://github.com/3dem/relion.git ${TARGET}
cd ${TARGET}
git checkout ${RELION_TAG}

mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}
cmake -DFORCE_OWN_FFTW=ON -DFORCE_OWN_FLTK=ON -DCUDA_ARCH=75 -DCUDA=ON ..
make -j 4

echo "export PATH=${PATH}:${BASE_DIR}/${TARGET}/${BUILD_DIR}/bin" |tee -a ~/.bashrc

