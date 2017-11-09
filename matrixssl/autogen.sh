#!/bin/sh -e

download() {
    if [ -d "matrixssl" ]; then
        rm -rf matrixssl
    fi
    echo "Cloning matrixssl repository..."
    git clone --quiet --progress --single-branch \
        --depth 2 https://github.com/matrixssl/matrixssl.git matrixssl
    echo "Cloning matrixssl repository...done"
}

build_contiki() {
    (echo "Building matrixssl for contiki..."
    cd matrixssl
    make clean
    CFLAGS="$CFLAGS -Os -mcpu=cortex-m3 -mthumb -mlittle-endian"
    #CFLAGS="$CFLAGS -ffunction-sections -fdata-sections"
    #CFLAGS="$CFLAGS -fshort-enums -fomit-frame-pointer -fno-strict-aliasing"
    #CFLAGS="$CFLAGS -Wall"
    LDFLAGS="-mcpu=cortex-m3 -mthumb -mlittle-endian -nostartfiles"
    make V=1 libs CC=arm-none-eabi-gcc CFLAGS="-DNO_MULTITHREADING $CFLAGS" LDFLAGS="$LDFLAGS"
    echo "Building matrixssl for contiki...done")
}

build_posix() {
    (echo "Building matrixssl for posix..."
    cd matrixssl
    POSIX_OPTIMIZATIONS="-Os -ffunction-sections -fdata-sections -Wl,--gc-sections"
    cp ../cryptoConfig.h configs/default/cryptoConfig.h
    make clean
    make libs CFLAGS="-DNO_MULTITHREADING $POSIX_OPTIMIZATIONS"
    echo "Building matrixssl for posix...done")
}
