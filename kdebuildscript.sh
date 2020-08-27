#!/bin/bash
cd /build/kdesrc-build
./kdesrc-build --initial-setup
source ~/.bashrc
export CC=/usr/bin/aarch64-linux-gnu-gcc
export  CXX=/usr/bin/aarch64-linux-gnu-g++

./kdesrc-build plasma-nano plasma-phone-components plasma-settings plasma-camera marble koko vvave okular plasma-angelfish plasma-samegame mtp-server kaidan peruse calindori index-fm maui-pix qrca keysmith --include-dependencies




