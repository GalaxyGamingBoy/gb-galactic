name := galactic-armada
deps := src/$(name).o \
		libs/sprobj.o \
		src/main/utils/vblank.o \
		src/main/states/title-screen/title-screen-state.o

title := Galactic Armada
licensee := MM
version := 1

RGBASM := rgbasm
RGBLINT := rgblink
RGBFIX := rgbfix

all: $(name).gb
	$(RGBFIX) -v -t "$(title)" -k "$(licensee)" -i $(name) -n $(version) -p 0xFF src/gen/$(name).gb

$(name).gb: $(deps)
	$(RGBLINT) -o src/gen/$(name).gb $(deps)

%.o: %.asm
	$(RGBASM) -L -o $@ $^
	
hardware:
	wget https://raw.githubusercontent.com/gbdev/hardware.inc/master/hardware.inc

gfx:
	python3 gfx.py

clean:
	rm -r src/gen/
	rm $(deps) src/gen/$(name).gb

run: $(name).gb
	Emulicious ./src/gen/$(name).gb
