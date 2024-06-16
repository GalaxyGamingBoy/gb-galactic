name := galactic-armada

src := src/main/utils/vblank.o \
		src/main/utils/text.o \
		src/main/utils/memory.o \
		src/main/utils/input.o \
		src/main/utils/background.o \
		src/main/utils/sprites.o \
		src/main/states/title-screen/title-screen-state.o \
		src/main/states/story/story-state.o \
		src/main/states/gameplay/gameplay-state.o \
		src/main/states/gameplay/background.o \
		src/main/states/gameplay/hud.o \
		src/main/states/gameplay/interrupts.o

libs := libs/sprobj.o \
		libs/input.o

deps := src/$(name).o $(libs) $(src)

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
	rm $(deps)

run: $(name).gb
	Emulicious ./src/gen/$(name).gb
