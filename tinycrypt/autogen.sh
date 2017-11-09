#!/bin/sh -e

download() {
    if [ -d "tinycrypt" ]; then
        rm -rf tinycrypt
    fi
    echo "Cloning and building tinycrypt..."
    git clone --quiet --progress --single-branch \
        --depth 2 https://github.com/01org/tinycrypt.git tinycrypt
    echo "Cloning and building tinycrypt...done"
}

build_contiki() {
    echo "Nothing to be done"
}

build_posix() {
    echo "Nothing to be done"
}
