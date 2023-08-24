#!/bin/bash
# This script is called by on-node-configured.sh
# https://github.com/aws-samples/aws-pcluster-post-samples
# https://catalog.us-east-1.prod.workshops.aws/workshops/6735ed89-c2de-4180-904c-40ac9fba7419/en-US/setup/pcluster/pcluster-post

#apt-get install libfftw3-dev libtiff-dev -y

sudo apt-get update
sudo apt install cmake git build-essential mpi-default-bin mpi-default-dev libfftw3-dev libtiff-dev libpng-dev ghostscript libxft-dev
sudo apt-get install libx11-dev libxft-dev -y