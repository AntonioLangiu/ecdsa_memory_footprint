#!/bin/sh -e

download() {
    if [ -d "libtomcrypt" ]; then
        rm -rf "libtomcrypt"
    fi
    echo "Downloading and extracting mbedtls..."
    git clone --quiet --progress --single-branch -b master \
        --depth 2 https://github.com/libtom/libtomcrypt.git libtomcrypt
    echo "Downloading and extracting mbedtls...done"
}

build_contiki() {
    echo "nothing to do"
}

build_posix() {
    (echo "Building libtomcrypt for posix..."
    cd libtomcrypt
    POSIX_OPTIMIZATIONS="-Os -ffunction-sections -fdata-sections -Wl,--gc-sections"
    CONFIGS="-DLTC_NOTHING -DLTC_NO_CURVES -DLTC_ECC256 -DLTC_MECC -DLTC_SHA256 -DLTC_DER"
    CONFIGS="$CONFIGS -DUSE_LTM -DLTM_DESC -DLTC_SMALL_CODE"
    make clean
    make CFLAGS="$CONFIGS $POSIX_OPTIMIZATIONS" EXTRALIBS="-ltommath"
    echo "Building libtomcrypt for posix...done")
}
