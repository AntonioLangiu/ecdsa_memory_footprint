#ifndef VERIFY_H_
#define VERIFY_H_

#include <stdint.h>
#include "sample_data.h"

int sha256(const void* buffer, int buffer_size, void* hash);
int verify(const uint8_t* pub_key, const uint8_t* signature, const uint8_t* data, int data_size);

static inline int test() {
    int ret = -1;
#ifdef WITH_HASH
	uint8_t hash[32];
	ret = sha256(data_g, 128, hash);
	if (ret) {
		printf("sha256 returned %d\n", ret);
		return ret;
	}
	if (memcmp(hash, hash_g, 32) != 0) {
		printf("ERR: Calculated hash is not correct\n");
		return 1;
	}
	printf("sha256 correcly calculated\n");
#endif
#ifdef WITH_VERIFICATION
	ret = verify(pub_key_g, sig_g, hash_g, 32);
	if (ret) {
		printf("verify returned %d\n", ret);
		return ret;
	}
	printf("Verification passed\n");
#endif
	return 0;
}

#endif
