# Contiki Makefile
ifndef TARGET
	TARGET=srf06-cc26xx
	BOARD=sensortag/cc2650
endif

CONTIKI_PROJECT = runner

all: $(CONTIKI_PROJECT)

MBEDTLS=mbedtls-2.6.0

INCLUDE+=-I$(MBEDTLS)/include

PROJECT_SOURCEFILES += verify.c

CONTIKI_WITH_IPV6 = 0
CONTIKI_WITH_RIME = 1

SMALL=1

PROJECT_LIBRARIES=$(MBEDTLS)/library/libmbedcrypto.a

POSIX_OPTIMIZATIONS=-Os -ffunction-sections -fdata-sections -Wl,--gc-sections -std=c99
# CONFIGURATION FOR POSIX BUILD
posix: verify.c
	gcc -Wall $(POSIX_OPTIMIZATIONS) $(INCLUDE) $(VERIFY_CONF) $< $(PROJECT_LIBRARIES) -o verify.exec

CONTIKI = ../ext/contiki
include $(CONTIKI)/Makefile.include
