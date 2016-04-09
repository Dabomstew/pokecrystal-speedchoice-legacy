PYTHON := python
MD5 := md5sum -c --quiet

.SUFFIXES:
.PHONY: all clean crystal crystal11
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
	rm -f $(roms) $(crystal_obj) $(crystal11_obj) $(roms:.gbc=.map) $(roms:.gbc=.sym)

compare: crystal-speedchoice.gbc
	@$(MD5) roms.md5

%.asm: ;

%.o: dep = $(shell $(includes) $(@D)/$*.asm)
%.o: %.asm $$(dep)
	rgbasm -o $@ $<

crystal-speedchoice.gbc: $(crystal_obj)
	rgblink -n crystal-speedchoice.sym -m crystal-speedchoice.map -o $@ $^
	rgbfix -Cjv -i KAPB -k 01 -l 0x33 -m 0x10 -p 0 -n 2 -r 3 -t PM_CRYSTAL $@

%.png: ;
%.2bpp: %.png ; $(gfx) 2bpp $<
%.1bpp: %.png ; $(gfx) 1bpp $<
%.lz: % ; $(gfx) lz $<

%.pal: %.2bpp ;
gfx/pics/%/normal.pal gfx/pics/%/bitmask.asm gfx/pics/%/frames.asm: gfx/pics/%/front.2bpp ;
%.bin: ;
%.blk: ;
%.tilemap: ;
