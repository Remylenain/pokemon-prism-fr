.PHONY: all clean

CC ?= gcc

CFLAGS := -O3 -march=native -mtune=native -flto -std=c17 -Wall -Wextra -pedantic \
	 -Wno-parentheses -Wno-dangling-else -Wno-uninitialized -Wno-unused-parameter

utils := \
	bankends \
	bspcomp \
	gbspatch \
	gbstrim \
	ipspatch \
	lzcomp \
	pngtrim \
	pokepic \
	qrconv \
	rendergifs \
	scaninc \
	textcomp \
	xorbanks

extra := \
	libplum.o \
	libqrgen.o \
	parsemap.o

all: $(utils)
	@:

clean:
	rm -f $(utils) $(extra)
	${MAKE} clean -C lz/

bspcomp: CFLAGS += -Wno-pointer-sign -Wno-implicit-fallthrough
bspcomp: bsp/bspcomp.c
	${CC} ${CFLAGS} $< -o $@

lzcomp: lz/lzcomp
	cp -f $< $@

lz/lzcomp: lz/src/*.c lz/src/*.h
	${MAKE} -C lz/

qrconv: qrconv.c libqrgen.o
	${CC} ${CFLAGS} $^ -o $@

pokepic rendergifs: CFLAGS += -Wno-keyword-macro
pokepic rendergifs: %: %.c libplum.o
	${CC} ${CFLAGS} $^ -o $@

bankends gbspatch: %: %.c parsemap.o
	${CC} ${CFLAGS} $^ -o $@

ipspatch: CFLAGS += -Wno-unused-result
gbstrim ipspatch pngtrim scaninc textcomp xorbanks: %: %.c
	${CC} ${CFLAGS} $< -o $@

# rewrite all the flags (instead of adding) to remove -O3 (replaced by -Ofast) and -Wextra (too many fake warnings)
libplum.o: CFLAGS = -Ofast -march=native -mtune=native -std=c17 -Wall -pedantic \
	-Wno-parentheses -Wno-dangling-else -Wno-uninitialized -Wno-keyword-macro -Wno-tautological-constant-compare
%.o: %.c %.h
	${CC} ${CFLAGS} -c $<
