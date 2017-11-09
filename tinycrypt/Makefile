# Contiki Makefile
ifndef TARGET
	TARGET=srf06-cc26xx
	BOARD=sensortag/cc2650
endif

CONTIKI_PROJECT = runner

all: $(CONTIKI_PROJECT)

INCLUDE+=-Itinycrypt/lib/include
CFLAGS=$(INCLUDE)

SRC_DIR=tinycrypt/lib/source
SRC_FILES=$(shell find $(SRC_DIR) -type f -print)

PROJECT_SOURCEFILES=verify.c $(notdir $(SRC_FILES))
CONTIKIDIRS+=$(SRC_DIR)

CONTIKI_WITH_IPV6 = 0
CONTIKI_WITH_RIME = 1

SMALL=1

POSIX_OPTIMIZATIONS=-Os -ffunction-sections -fdata-sections -Wl,--gc-sections -std=c99
# CONFIGURATION FOR POSIX BUILD
posix: verify.c
	gcc -Wall $(POSIX_OPTIMIZATIONS) $(INCLUDE) $(VERIFY_CONF) -DuECC_POSIX \
		$(SRC_FILES) $< -o verify.exec

CONTIKI = ../ext/contiki
include $(CONTIKI)/Makefile.include
