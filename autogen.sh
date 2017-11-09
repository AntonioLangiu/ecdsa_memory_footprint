#!/bin/sh -e

# Fetch external dependencies
if [ -d "ext" ]; then
    rm -rf ext
fi
mkdir ext

# Clone the contiki repository and its submodules
echo "Cloning the Contiki repository..."
git clone --quiet --progress --recurse-submodules \
    --single-branch --depth 2 https://github.com/contiki-os/contiki.git \
    ext/contiki
echo "Cloning the Contiki repository...done"
