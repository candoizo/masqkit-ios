#!/bin/sh
export FINALPACKAGE=1
export THEOS_DEVICE_IP=192.168.12.207
export THEOS_PACKAGE_DIR=/home/candoizo/Code/ios/2019/masqkit/public
cd src
make clean-packages
make clean package install
cd ..
cd 11
make clean-packages
make clean package install
cd ..
cd music
make clean-packages
make clean package install
cd ..
cd spotify
make clean-packages
make clean package install

#themes
cd ../customcoverthemepack
make clean-packages
make clean package install

cd ../basic
make clean-packages
make clean package install
