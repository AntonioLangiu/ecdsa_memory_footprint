# Contiki Makefile
ifndef TARGET
	TARGET=srf06-cc26xx
	BOARD=sensortag/cc2650
endif

CONTIKI_PROJECT = runner

all: $(CONTIKI_PROJECT)

PROJECT_SOURCEFILES=verify.c

INCLUDE=-Iwolfssl

CFLAGS+=$(INCLUDE) $(VERIFY_CONF)
PROJECT_LIBRARIES=wolfssl/src/.libs/libwolfssl.a

CONTIKI_WITH_IPV6 = 0
CONTIKI_WITH_RIME = 1

SMALL=1

POSIX_OPTIMIZATIONS=-Os -ffunction-sections -fdata-sections -Wl,--gc-sections -std=c99
# CONFIGURATION FOR POSIX BUILD
posix: verify.c
	gcc -Wall $(POSIX_OPTIMIZATIONS) $(INCLUDE) $(VERIFY_CONF)  $< $(PROJECT_LIBRARIES) -o verify.exec

CONTIKI = ../ext/contiki
include $(CONTIKI)/Makefile.include
