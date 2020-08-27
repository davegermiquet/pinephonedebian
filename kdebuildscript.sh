#!/bin/bash

export CC=/usr/bin/aarch64-linux-gnu-gcc
export CXX=/usr/bin/aarch64-linux-gnu-g++
export Qt5_DIR=/build/qt5
export CROSS_COMPILE=/usr/bin/aarch64-linux-gnu-
cd /build/qt5

mkdir -p /build/qt5build/sysroot
./configure -release -opengl es2 \
 -sysroot /build/qt5build/sysroot -opensource -confirm-license -skip qtwayland -skip qtlocation -skip qtscript -make libs \
  -prefix /usr/local/qt5 -no-use-gold-linker -v -no-gbm

cd /build/kdesrc-build

./kdesrc-build --initial-setup
source ~/.bashrc

cd /build/kdesrc-build


./kdesrc-build plasma-nano plasma-phone-components plasma-settings plasma-camera marble koko vvave okular plasma-angelfish mtp-server kaidan peruse calindori index-fm maui-pix qrca keysmith --include-dependencies




