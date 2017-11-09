#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <mbedtls/sha256.h>
#include <mbedtls/ecdsa.h>
#include <mbedtls/ecp.h>

#include "../verify.h"

#define CHECK_RET(ret)      \
    if (++i && ret != 0) {  \
        goto failure;       \
    }

int sha256(const void* buffer, int buffer_size, void* hash) {
    mbedtls_sha256_context ctx;
    mbedtls_sha256_starts(&ctx, 0);
    mbedtls_sha256_update(&ctx, buffer, buffer_size);
    mbedtls_sha256_finish(&ctx, hash);
    return 0;
}

int verify(const uint8_t* pub_key, const uint8_t* signature, const uint8_t* data, int data_size) {
    int ret = -1, i=0;
    mbedtls_ecp_group grp[1];
    // It requires to allocate memory
    mbedtls_ecp_group_init(grp);
    ret = mbedtls_ecp_group_load(grp, MBEDTLS_ECP_DP_SECP256R1);
    CHECK_RET(ret);

    mbedtls_mpi r[1];
    mbedtls_mpi s[1];
    mbedtls_mpi_init(r);
    mbedtls_mpi_init(s);

    mbedtls_mpi_read_binary(r, signature+4, 32);
    CHECK_RET(ret);
    mbedtls_mpi_read_binary(s, signature+38, 32);
    CHECK_RET(ret);

    mbedtls_ecp_point point[1];
    mbedtls_ecp_point_init(point);
    mbedtls_ecp_point_read_binary(grp, point, pub_key, 65);
    CHECK_RET(ret);

    ret = mbedtls_ecdsa_verify(grp, data, data_size, point, r, s);
    CHECK_RET(ret);
    i = 0;
failure:
    mbedtls_ecp_group_free(grp);
    mbedtls_ecp_point_free(point);
    mbedtls_mpi_free(r);
    mbedtls_mpi_free(s);
    return i;
}

#ifndef CONTIKI
int main(int argc, char**argv) {
	return test();
}
#endif
