#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include "../verify.h"

#include <wolfssl/options.h>
#include <wolfssl/wolfcrypt/sha256.h>
#include <wolfssl/wolfcrypt/ecc.h>

#define CHECK_RET(ret) \
    if (++i && ret) {\
        return i; \
    } 

int sha256(const void* buffer, int buffer_size, void* hash) {
    int ret, i=0;
    wc_Sha256 ctx;
    ret = wc_InitSha256(&ctx);
    CHECK_RET(ret);
    ret = wc_Sha256Update(&ctx, buffer, buffer_size);
    CHECK_RET(ret);
    ret = wc_Sha256Final(&ctx, hash);
    CHECK_RET(ret);
    wc_Sha256Free(&ctx);
    return 0;
}

int verify(const uint8_t* pub_key, const uint8_t* signature, const uint8_t* data, int data_size) {
    int ret, i=0;
    struct ecc_key* key = malloc(sizeof(struct ecc_key));
    ret = wc_ecc_init(key);
    CHECK_RET(ret)
    ret = wc_ecc_import_x963_ex(pub_key, 65, key, ECC_SECP256R1);
    CHECK_RET(ret);
    int stat;
    ret = wc_ecc_verify_hash(signature, 71, data, data_size, &stat, key);
    CHECK_RET(ret);
    CHECK_RET(stat != 1);
    wc_ecc_free(key);
    return 0;
}

#ifndef CONTIKI
int main(int argc, char**argv) {
    return test();
}
#endif
