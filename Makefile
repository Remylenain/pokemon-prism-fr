MAKEFLAGS += --no-builtin-rules

roms := pokeprism.gbc pokeprism_nodebug.gbc

pokeprism_obj := \
	audio.o \
	gfx.o \
	main.o \
	maps.o \
	text.o \
	wram.o

pokeprism_nodebug_obj := $(pokeprism_obj:.o=_nodebug.o)

gbs_obj := \
	audio_gbs.o \
	gbs.o \
	wram_gbs.o

patch_components := \
	patch/_debug.ips \
	patch/_gbspatch.bin \
	patch/_hashes.txt \
	patch/_release.ips \
	patch/_version.txt \
	patch/_xorpatch.bin


### Build utils

ifeq (,$(shell which sha1sum))
SHA1 := shasum
else
SHA1 := sha1sum
endif

RGBDS ?=
RGBASM  ?= ${RGBDS}rgbasm
RGBFIX  ?= ${RGBDS}rgbfix
RGBLINK ?= ${RGBDS}rgblink
RGBGFX  ?= ${RGBDS}rgbgfx

ifeq ($(strip $(shell echo $$PYTHON)),)
PYTHON := python3
endif
DEDENC        := ${PYTHON} dedenc.py
GFX           := ${PYTHON} gfx.py

POKEPICOUTPUTS = front.2bpp back.2bpp normal.pal shiny.pal frames.asm bitmask.asm dimensions.asm

### Build targets

.SUFFIXES:
.PHONY: all prism nodebug gbs freespace genimages patch clean tidy utils baserom.gbc trimfiles
.SECONDEXPANSION:
.PRECIOUS:
.SECONDARY:

all: freespace nodebug gbs genimages
prism: pokeprism.gbc contents/contents.link
nodebug: pokeprism_nodebug.gbc contents/contents.link
gbs: pokeprism.gbs
freespace: contents/bank_ends.txt
patch: pokeprism.bsp baserom.gbc

clean: tidy
	find . -name '*.lz' -delete
	find gfx -name '*.[12x]bpp' -delete
	find audio/ded -name '*.ded' -delete
	find patch -name '*.tmp' -delete
	for name in ${POKEPICOUTPUTS}; do find gfx/pics -name $$name -delete; done

tidy:
	${RM} $(roms) \
	      $(roms:.gbc=.sym) \
	      $(roms:.gbc=.map) \
	      gbs.map \
	      $(pokeprism_obj) \
	      $(pokeprism_nodebug_obj) \
	      $(gbs_obj) \
	      $(patch_components) \
	      pokeprism.bsp \
	      pokeprism.gbs
	${RM} -r genimages/
	${MAKE} clean -C utils/
	find . -name __pycache__ -type d -exec ${RM} -r {} +

trimfiles:
	find gfx -iname '*.png' -exec utils/pngtrim {} \;

utils:
	${MAKE} -C utils/


ifdef BUILD_DATE
BUILD_DATE_FLAG := -DBUILD_DATE=${BUILD_DATE}
else
BUILD_DATE_FLAG :=
endif

RGBASMFLAGS  = ${BUILD_DATE_FLAG} -hL
RGBLINKFLAGS = -M

$(pokeprism_obj):         RGBASMFLAGS += -DDEBUG_MODE
$(pokeprism_nodebug_obj): RGBASMFLAGS +=
$(gbs_obj):               RGBASMFLAGS += -DGBS

pokeprism.gbc:         RGBLINKFLAGS += -p 0xff
pokeprism_nodebug.gbc: RGBLINKFLAGS += -p 0xff
pokeprism.gbs:         RGBLINKFLAGS += -p 0x00

# Build utils when building the rom.
# This has to happen before the rules are processed, since that's when scaninc is run.
ifeq (,$(filter clean tidy utils,$(MAKECMDGOALS)))

$(info $(shell $(MAKE) -C utils))

# The dep rules have to be explicit or else missing files won't be reported.
# As a side effect, they're evaluated immediately instead of when the rule is invoked.
# It doesn't look like $(shell) can be deferred so there might not be a better way.
preinclude_deps := includes.asm $(shell utils/scaninc includes.asm)
define DEP
$1: $2 $$(shell utils/scaninc $2) $(preinclude_deps)
	$$(RGBASM) $$(RGBASMFLAGS) -o $$@ $$<
endef

# Dependencies for shared objects
$(foreach obj, $(pokeprism_obj), $(eval $(call DEP,$(obj),$(obj:.o=.asm))))
$(foreach obj, $(pokeprism_nodebug_obj), $(eval $(call DEP,$(obj),$(obj:_nodebug.o=.asm))))
$(foreach obj, $(gbs_obj), $(eval $(call DEP,$(obj),$(patsubst %_gbs.asm,%.asm,$(obj:.o=.asm)))))

endif


pokeprism_opt         = -Cjv -t PM_PRISM -i PRSM -k 01 -l 0x33 -m 0x10 -r 3 -p 0xff
pokeprism_nodebug_opt = -Cjv -t PM_PRISM -i PRSM -k 01 -l 0x33 -m 0x10 -r 3 -p 0xff

%.gbc: $$(%_obj) contents/*.link
	${RGBLINK} $(RGBLINKFLAGS) -n $*.sym -m $*.map -l contents/contents.link -o $@ $(filter %.o,$^)
	${RGBFIX} $($*_opt) $@

pokeprism.gbs: $(gbs_obj) contents/gbs.link
	${RGBLINK} $(RGBLINKFLAGS) -m gbs.map -n gbs.sym -l contents/gbs.link -o $@ $(filter %.o,$^)
	utils/gbstrim $@

contents/bank_ends.txt: prism
	utils/bankends pokeprism.map > $@

genimages: pokeprism.gbc genimages.cfg
	${RM} -r $@
	mkdir $@
	utils/rendergifs $< $(patsubst %.gbc,%.sym,$<) genimages.cfg $@/


### Patch rules

pokeprism.bsp: $(patch_components)
	cd patch && ../utils/bspcomp patch.txt ../$@

baserom.gbc:
	stat $@ >/dev/null
	[ $(shell ${SHA1} -b $@ | cut -c 1-40) = f2f52230b536214ef7c9924f483392993e226cfb ]

patch/_debug.ips: all prism
	utils/ipspatch create pokeprism_nodebug.gbc pokeprism.gbc $@

patch/_gbspatch.bin: all
	utils/gbspatch pokeprism_nodebug.gbc pokeprism_nodebug.map pokeprism.gbs gbs.map patch/_gbspatch.tmp patch/_gbsresult.tmp
	utils/ipspatch create patch/_gbsresult.tmp pokeprism.gbs patch/_gbsips.tmp
	cat patch/_gbspatch.tmp patch/_gbsips.tmp > $@
	${RM} patch/_gbspatch.tmp patch/_gbsresult.tmp patch/_gbsips.tmp

patch/_hashes.txt: all
	printf "\\thexdata %s\\n" `${SHA1} -b pokeprism_nodebug.gbc | cut -c 1-40` > $@
	printf "\\thexdata %s\\n" `${SHA1} -b pokeprism.gbc | cut -c 1-40` >> $@
	printf "\\thexdata %s\\n" `${SHA1} -b pokeprism.gbs | cut -c 1-40` >> $@

patch/_release.ips: all prism
	utils/ipspatch create pokeprism.gbc pokeprism_nodebug.gbc $@

patch/_version.txt: pokeprism.gbc
	hexdump -s 252 -n 4 -v -e '"\t" "hexdata " 4/1 "%02x" "\n"' pokeprism.gbc > $@

patch/_xorpatch.bin: all baserom.gbc
	utils/xorbanks baserom.gbc pokeprism_nodebug.gbc $@


### File-specific rules

gfx/qrcodes/%.1bpp: gfx/qrcodes/%.asm
	utils/qrconv $< $@

data/landmarks/%.bin: DEPS = $(shell utils/scaninc data/landmarks/$*.asm)
data/landmarks/%.bin: data/landmarks/%.asm $$(DEPS)
	RGBASM=${RGBASM} RGBLINK=${RGBLINK} utils/asm2bin.sh $< $@

tilesets/%_collision.bin: tilesets/%_collision.asm constants/collision_constants.asm
	BSPCOMP=utils/bspcomp utils/coll2bin.sh $< $@

## Rule for gfx/pics: generated from a loop, because a rule cannot have multiple patterns

define POKEPICRULE
$(foreach FN,$(POKEPICOUTPUTS),$(1)$(FN)) &: $(1)framesheet.png $(1)back.png
	utils/pokepic $(1)
endef
$(foreach PICDIR,$(wildcard gfx/pics/*/),$(eval $(call POKEPICRULE,$(PICDIR))))

### Catch-all rules

%.lz: %
	utils/lzcomp -- $< $@

gfx/battle/%.2bpp: gfx/battle/%.png
	${GFX} 2bpp $<
gfx/tilesets/%.2bpp: gfx/tilesets/%.png
	${GFX} 2bpp $<
gfx/trainer_card/%.2bpp: gfx/trainer_card/%.png
	${GFX} 2bpp $<
gfx/trainers/%.2bpp: gfx/trainers/%.png
	${GFX} 2bpp $<

%.xbpp: %.png %.cfg
	${RGBGFX} @$(patsubst %.png,%.cfg,$<) -o $@ -- $<

%.2bpp: %.png
	${RGBGFX} -c '#ffffff,#aaaaaa,#555555,#000000' -o $@ -- $<

%.1bpp: %.png
	${RGBGFX} -c '#ffffff,#000000' -d 1 -o $@ -- $<

%.ded: %.wav
	${DEDENC} $< $@
