#!/bin/sh -e

download() {
    if [ -d "mbedtls-2.6.0" ]; then
        rm -r "mbedtls-2.6.0"
    fi
    echo "Downloading and extracting mbedtls..."
    {
        wget https://tls.mbed.org/download/mbedtls-2.6.0-apache.tgz
        TARFILE="mbedtls-2.6.0-apache.tgz"
        tar -zxvf $TARFILE
        rm $TARFILE
    } >/dev/null 2>&1
    echo "Downloading and extracting mbedtls...done"
}

build_contiki() {
    (echo "Building mbedtls for contiki..."
    cd mbedtls-2.6.0
    make clean
    sed -i 's/^\(#define MBEDTLS_TIMING_C\)/\/\/\1/g' include/mbedtls/config.h
    sed -i 's/^\(#define MBEDTLS_FS_IO\)/\/\/\1/g' include/mbedtls/config.h
    sed -i 's/^\(#define MBEDTLS_NET_C\)/\/\/\1/g' include/mbedtls/config.h
    # TODO THIS WILL NOT WORK ON CONTIKI BECAUSE I STILL HAVE TO DEFINE THE
    # CALLOC AND FREE IMPLEMENTATIONS:
    #* Enabling MBEDTLS_PLATFORM_MEMORY and specifying
    #* MBEDTLS_PLATFORM_{CALLOC,FREE}_MACROs will allow you to specify the
    #* alternate function at compile time.
    CFLAGS="-DMBEDTLS_NO_PLATFORM_ENTROPY -DMBEDTLS_PLATFORM_NO_STD_FUNCTIONS \
        -DMBEDTLS_PLATFORM_FPRINTF_ALT -DMBEDTLS_PLATFORM_PRINTF_ALT \
        -DMBEDTLS_PLATFORM_SNPRINTF_ALT -DMBEDTLS_PLATFORM_MEMORY"
    CFLAGS="$CFLAGS -Os -mcpu=cortex-m3 -mthumb -mlittle-endian -nodefaultlibs"
    CFLAGS="$CFLAGS -ffunction-sections -fdata-sections"
    CFLAGS="$CFLAGS -fshort-enums -fomit-frame-pointer -fno-strict-aliasing"
    CFLAGS="$CFLAGS -Wall -std=c99"
    LDFLAGS="-mcpu=cortex-m3 -mthumb -mlittle-endian -nostartfiles"
    make lib CC=arm-none-eabi-gcc CFLAGS="$CFLAGS" LDFLAGS="$LDFLAGS"
    echo "Building mbedtls for contiki...done")
}

build_posix() {
    (echo "Building mbedtls for posix..."
    cd mbedtls-2.6.0
    POSIX_OPTIMIZATIONS="-Os -ffunction-sections -fdata-sections -Wl,--gc-sections"
    cp ../small_config.h include/mbedtls/config.h
    make clean
    make lib CFLAGS="$POSIX_OPTIMIZATIONS"
    echo "Building mbedtls for posix...done")
}
