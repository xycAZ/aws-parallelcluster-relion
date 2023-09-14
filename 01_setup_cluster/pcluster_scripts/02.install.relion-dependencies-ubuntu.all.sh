#!/bin/bash
# This script is called by on-node-configured.sh
# https://github.com/aws-samples/aws-pcluster-post-samples
# https://catalog.us-east-1.prod.workshops.aws/workshops/6735ed89-c2de-4180-904c-40ac9fba7419/en-US/setup/pcluster/pcluster-post

#apt-get install libfftw3-dev libtiff-dev -y

sudo apt-get update
sudo apt-get install cmake git build-essential mpi-default-bin mpi-default-dev libfftw3-dev libtiff-dev libpng-dev ghostscript libxft-dev -y
sudo apt-get install libx11-dev libxft-dev -y

# Install S3 Mountpoint if it's not installed
if [ ! -x "$(which mount-s3)" ]; then
    sudo apt-get install -y curl libfuse-dev pkg-config fuse libclang-dev cargo
    #sudo yum install -y fuse fuse-devel cmake3 clang-devel
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && source "$HOME/.cargo/env"
    source "$HOME/.cargo/env"
    sudo chmod -R 777 /tmp/scripts
    git clone --recurse-submodules https://github.com/awslabs/mountpoint-s3.git
    cd mountpoint-s3/
    cargo build --release
    sudo mv target/release/mount-s3 /usr/bin/
fi

# get network throughput from ec2 instance
instance_type=$(curl -s http://169.254.169.254/latest/meta-data/instance-type)
region=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep region|awk -F\" '{print $4}')
network=$(aws ec2 --region ${region} describe-instance-types --instance-types ${instance_type} --query "InstanceTypes[].[NetworkInfo.NetworkPerformance]" --output text | grep -o '[0-9]\+')

# Mount S3 Bucket
sudo mkdir -p ${1}
sudo chmod 777 ${1}
mount-s3 --maximum-throughput-gbps ${network} ${2} ${1}