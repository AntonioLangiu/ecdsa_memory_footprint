#!/bin/sh -e

download() {
if [ -d "micro-ecc" ]; then
    rm -rf micro-ecc
fi
echo "Cloning and building micro-ecc..."
git clone --quiet --progress --single-branch \
    --depth 2 https://github.com/kmackay/micro-ecc.git micro-ecc
echo "Cloning and building micro-ecc...done"
}

build_contiki() {
    echo "nothig to be done"
}

build_posix() {
    echo "nothig to be done"
}
