#!/usr/bin/env bash
set -x
YUM=`which yum`
APT=`which yum`
if [ -d $YUM ]; then
  echo "Yum is detected installing required packages for the platform."
  yum install git wget curl
elif [ -d $APT ]; then
  echo "Apt is detected installing required packages for the platform."
  apt-get install git wget curl -y
else 
  echo "No supported Package Management"
fi
