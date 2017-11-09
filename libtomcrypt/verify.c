#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <tomcrypt.h>

#include "../verify.h"

#define CHECK_RET(ret)      \
    if (++i && ret != CRYPT_OK) {  \
        return i; \
    }

int sha256(const void* buffer, int buffer_size, void* hash) {
    int ret = -1, i=0;
    hash_state ctx;
    ret = sha256_init(&ctx);
    CHECK_RET(ret);
    ret = sha256_process(&ctx, buffer, buffer_size);
    CHECK_RET(ret);
    ret = sha256_done(&ctx, hash);
    CHECK_RET(ret);
    return 0;
}

int verify(const uint8_t* pub_key, const uint8_t* signature, const uint8_t* data, int data_size) {
    int ret = -1, i=0;
    init_LTM();
    ecc_key key;
    ret = ecc_ansi_x963_import(pub_key, 65, &key);
    CHECK_RET(ret);
    int stat = 0;
    ret =  ecc_verify_hash(signature, 70, data, data_size, &stat, &key);
    CHECK_RET(ret);
    if (stat != 1) {
        printf("invalid signature\n");
        return -1;
    }
    return 0;
}

#ifndef CONTIKI
int main(int argc, char**argv) {
    return test();
}
#endif
