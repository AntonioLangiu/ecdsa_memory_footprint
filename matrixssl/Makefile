# Contiki Makefile
ifndef TARGET
	TARGET=srf06-cc26xx
	BOARD=sensortag/cc2650
endif

CONTIKI_PROJECT = runner

all: $(CONTIKI_PROJECT)

MATRIXSSL=matrixssl

INCLUDE+=-I$(MATRIXSSL) -I$(MATRIXSSL)/configs/default
CFLAGS+=$(INCLUDE)

PROJECT_SOURCEFILES += verify.c

CONTIKI_WITH_IPV6 = 0
CONTIKI_WITH_RIME = 1

SMALL=1

PROJECT_LIBRARIES=$(MATRIXSSL)/crypto/libcrypt_s.a $(MATRIXSSL)/core/libcore_s.a

POSIX_OPTIMIZATIONS=-Os -ffunction-sections -fdata-sections -Wl,--gc-sections
# CONFIGURATION FOR POSIX BUILD
posix: verify.c
	gcc -Wall $(POSIX_OPTIMIZATIONS) $(INCLUDE) $(VERIFY_CONF) $< $(PROJECT_LIBRARIES) -o verify.exec

CONTIKI = ../ext/contiki
include $(CONTIKI)/Makefile.include
