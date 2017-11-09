#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <assert.h>

#include "../verify.h"

#include "sha2.h"
#include "crypto.h"

int sha256(const void* buffer, int buffer_size, void* hash) {
    // This functions does not return any error??! 
    dtls_sha256_ctx ctx256;
    dtls_sha256_init(&ctx256);
    dtls_sha256_update(&ctx256, (unsigned char*)buffer, buffer_size);
    dtls_sha256_final(hash, &ctx256);
    return 0;
}

int verify(const uint8_t* pub_key, const uint8_t* signature, const uint8_t* data, int data_size) {
    int ret = -1;
    assert(data_size==32);
    ret = dtls_ecdsa_verify_sig_hash(pub_key+1, pub_key+33, 32, data, 32, signature+4, signature+38);
    if (ret != 0) {
        return 1;
    }
    return 0;
}

#ifndef CONTIKI
int main(int argc, char**argv) {
    return test();
}
#endif
