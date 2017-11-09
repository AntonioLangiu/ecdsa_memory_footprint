#include <stdio.h>
#include <stdlib.h>
#include <string.h>


#include <tinycrypt/ecc_dsa.h>
#include <tinycrypt/sha256.h>

#include "../verify.h"

#define CHECK_RET(ret) \
{\
    if (++i && ret != 1) { \
        return i; \
    }               \
}

int sha256(const void* buffer, int buffer_size, void* hash) {
    int ret = -1, i=0;
    struct tc_sha256_state_struct ctx;
    ret = tc_sha256_init(&ctx);
    CHECK_RET(ret);
    ret = tc_sha256_update(&ctx, (const uint8_t *) buffer, buffer_size);
    CHECK_RET(ret);
    ret = tc_sha256_final(hash, &ctx);
    CHECK_RET(ret);
    return 0;
}

int verify(const uint8_t* pub_key, const uint8_t* signature, const uint8_t* data, int data_size) {
    int i = 0, ret = -1;
    // tinycrypt does not support the DER format and we have to create a key
    // where the first 32 bytes are r and the next 32 are s
    uint8_t sig_raw[64];
    memcpy(sig_raw, signature+4, 32);
    memcpy(sig_raw+32, signature+38, 32);
    ret = uECC_verify(&pub_key[1], (uint8_t *) data, data_size, sig_raw, uECC_secp256r1());
    CHECK_RET(ret);
    return 0;
}

#ifndef CONTIKI
int main(int argc, char**argv) {
    return test();
}
#endif
