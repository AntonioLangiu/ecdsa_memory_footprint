#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include "../verify.h"

#include "crypto/cryptoApi.h"

#define CHECK_RET(ret) \
    if (++i && ret) { \
        return i; \
    }

int sha256(const void* buffer, int buffer_size, void* hash) {
    int ret, i=0;
    psSha256_t sha256;
    ret = psSha256Init(&sha256);
    CHECK_RET(ret);
    psSha256Update(&sha256, buffer, buffer_size);
    psSha256Final(&sha256, hash);
    return 0;
}

int verify(const uint8_t* pub_key, const uint8_t* signature, const uint8_t* data, int data_size) {
    int ret, i=0, status;
    psPool_t *pool = NULL;
    const psEccCurve_t *curve;
    ret = getEccParamById(IANA_SECP256R1, &curve);
    CHECK_RET(ret);
    psEccKey_t *key;
    ret = psEccNewKey(pool, &key, curve);
    CHECK_RET(ret);
    ret = psEccX963ImportKey(pool, pub_key, 65, key, curve);
    CHECK_RET(ret);
    ret = psEccDsaVerify(pool, key, data, data_size, signature, 70, &status, NULL);
    CHECK_RET(ret < 0);
    CHECK_RET(status != 1);
    return 0;
}

#ifndef CONTIKI
int main(int argc, char**argv) {
    return test();
}
#endif
