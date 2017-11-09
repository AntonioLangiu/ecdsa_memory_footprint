#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include "micro-ecc/uECC.h"
#include "../verify.h"

int sha256(const void* buffer, int buffer_size, void* hash) {
    // Considering taht this library does not implements the sha256 digest I
    // will not evaluate it
    return 1;
}

uint8_t sig_raw[64];

int verify(const uint8_t* pub_key, const uint8_t* signature, const uint8_t* data, int data_size) {
    // uncompressed point but without the 0x04 prefix
    memcpy(sig_raw, signature+4, 32);
    memcpy(sig_raw+32, signature+38, 32);
    int ret = uECC_verify(pub_key+1, data, data_size, sig_raw, uECC_secp256r1());
    if (ret != 1) {
        return 1;
    }
    return 0;
}

#ifndef CONTIKI
int main(int argc, char**argv) {
    return test();
}
#endif
