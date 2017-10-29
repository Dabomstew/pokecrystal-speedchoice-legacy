PYTHON := python
RGBDS := $(shell dirname $(shell which rgbasm))
ASM := $(RGBDS)/rgbasm
LD := $(RGBDS)/rgblink
FIX := $(RGBDS)/rgbfix

.SUFFIXES:
.PHONY: all clean crystal
.SECONDEXPANSION:
.PRECIOUS: %.2bpp %.1bpp

poketools := extras/pokemontools
gfx       := $(PYTHON) gfx.py
includes  := $(PYTHON) $(poketools)/scan_includes.py


crystal_obj := \
wram.o \
main.o \
lib/mobile/main.o \
home.o \
audio.o \
maps.o \
engine/events.o \
engine/credits.o \
data/egg_moves.o \
data/evos_attacks.o \
data/pokedex/entries.o \
misc/crystal_misc.o \
text/common_text.o \
gfx/pics.o


roms := crystal-speedchoice.gbc

all: $(roms)
crystal: crystal-speedchoice.gbc

clean:
	rm -f $(roms) $(crystal_obj) $(roms:.gbc=.map) $(roms:.gbc=.sym)

%.asm: ;

%.o: dep = $(shell $(includes) $(@D)/$*.asm)
%.o: %.asm $$(dep)
	$(ASM) -o $@ $<

crystal-speedchoice.gbc: $(crystal_obj)
	$(LD) -n crystal-speedchoice.sym -m crystal-speedchoice.map -o $@ $^
	$(FIX) -Cjv -i KAPB -k 01 -l 0x33 -m 0x10 -p 0 -n 3 -r 3 -t PM_CRYSTAL $@

%.png: ;
%.2bpp: %.png ; $(gfx) 2bpp $<
%.1bpp: %.png ; $(gfx) 1bpp $<
%.lz: % ; $(gfx) lz $<

%.pal: %.2bpp ;
gfx/pics/%/normal.pal gfx/pics/%/bitmask.asm gfx/pics/%/frames.asm: gfx/pics/%/front.2bpp ;
%.bin: ;
%.blk: ;
%.tilemap: ;
