#!/bin/sh -e

download() {
if [ -d "tinydtls" ]; then
    rm -rf tinydtls
fi
echo "Cloning and building tinydtls..."
git clone --quiet --progress --single-branch \
    --depth 2 https://git.eclipse.org/r/tinydtls/org.eclipse.tinydtls tinydtls
echo "Cloning and building tinydtls...done"
}

build_contiki() {
    echo "nothing to be done"
}

build_posix() {
    (echo "Building tinydtls..."
    cd tinydtls
    POSIX_OPTIMIZATIONS="-Os -ffunction-sections -fdata-sections -Wl,--gc-sections"
    autoreconf -i --force
    ./configure
    make libtinydtls.a CFLAGS="$POSIX_OPTIMIZATIONS"
    echo "Building tinydtls...done")
}
