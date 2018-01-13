# ECDSA memory footprint

This repository includes scripts and code to evaluate the memory
footprint of some libraries implementing 
[ECC](https://en.wikipedia.org/wiki/Elliptic-curve_cryptography)
and [SHA-256](https://en.wikipedia.org/wiki/SHA-2)
functions.

## Libraries

The comparison considers just the *secp256r1* curve, that is implemented
by all this libraries:

 - [polarssl](https://github.com/ARMmbed/mbedtls)
 - [matrixssl](https://github.com/matrixssl/matrixssl)
 - [wolfssl](https://github.com/wolfSSL/wolfssl)
 - [tinydtls](https://projects.eclipse.org/projects/iot.tinydtls)
 - [tinycrypt](https://github.com/01org/tinycrypt)
 - [micro-ecc](https://github.com/kmackay/micro-ecc) (does not implements sha256)
 - [libtomcrypt](https://github.com/libtom/libtomcrypt)

## Some considerations

The difference in size is mainly related to the complexity and the set of
features present in the libraries.

The goal of this comparison is to find the smallest library to implement
ECDSA validation inside a bootloader that must be as small
as possible. For this reason the set of features included in many libraries
are not needed in this application.

## Evaluation

The result of this comparison for Posix systems can be seen in the table below.
This size includes also the size of the main;

| Library     | SHA2 | ECC   | ECDSA |
|-------------|------|-------|-------|
| tinydtls    | 3800 | 7531  | 9888  |
| polarssl    | 6056 | 23046 | 27735 |
| matrixssl   | 3864 | 29103 | 34022 |
| micro-ecc   |  /   | 8970  |   /   |
| tinycrypt   | 3656 | 8968  | 11241 |
| wolfssl     | 4592 | 31443 | 34777 |
| libtomcrypt | 4354 | 35959 | 38256 |

* micro-ecc does not includes the digest calculation;
* libtomcrypt does not contains all the symbols of libtommath that is loaded at runtime;

## Build

The build system has been tested with an Ubuntu Trusty machine. I'm providing
a reproducible environment using Vagrant. Type `vagrant up` and `vagrant ssh`
to open a shell into the VM and then run the `./run.sh` script located
in the shared /vagrant folder. If everything was successfull at the end of the
build you should seen a table containing the various memory footprint.
