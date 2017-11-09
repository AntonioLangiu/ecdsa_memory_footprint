#!/bin/sh -e

download() {
    if [ -d "wolfssl" ]; then
        rm -rf "wolfssl"
    fi
    echo "Cloning wolfssl repository..."
    git clone --quiet --progress --recurse-submodules \
        --single-branch --depth 2 https://github.com/wolfSSL/wolfssl.git \
        wolfssl
    echo "Cloning wolfssl repository...done"
}

build_contiki() {
    (echo "Building wolfssl for contiki..."
    cd wolfssl
    autoreconf -i --force
    CONFIG="--enable-cryptonly --enable-ecc --enable-sha --enable-static --enable-ecccustcurves"
    CONFIG="$CONFIG --disable-filesystem"
    CFLAGS="-mcpu=cortex-m3 -mlittle-endian -mthumb --specs=nosys.specs"
    #CFLAGS="-DHAVE_ECC -DHAVE_ECC_VERIFY -DNO_RSA -DWOLFCRYPT_ONLY -DNO_CERTS"
    #CFLAGS="-DNO_RC4 -DNO_DES3"
    ./configure --host=arm-none-eabi $CONFIG "CFLAGS=$CFLAGS"
    make clean
    make
    echo "Building wolfssl for contiki...done")
}

build_posix() {
    (echo "Building wolfssl for posix..."
    cd wolfssl
    autoreconf -i --force
    POSIX_OPTIMIZATIONS="-Os -ffunction-sections -fdata-sections -Wl,--gc-sections"
    CONFIG="--enable-cryptonly --enable-ecc --enable-sha --enable-static --disable-nullcipher \
           --enable-singlethreaded --disable-aes --disable-filesystem --disable-rabbit --disable-rsa \
           --disable-dh --disable-md5 --disable-errorstrings --disable-oldtls --disable-arc4 \
           --disable-sha512 --disable-sha3 --disable-fastmath --disable-eccencrypt --disable-eccshamir \
           --disable-ecccustcurves --disable-aesgcm --disable-poly1305 --disable-chacha"
    ./configure $CONFIG CFLAGS="-DECC_USER_CURVES -DWOLFSSL_USER_IO -DUSE_SLOW_SHA -DNO_CERTS -DECC256"
    make clean
    make CFLAGS="$POSIX_OPTIMIZATIONS"
    echo "Building wolfssl for posix...")
}
