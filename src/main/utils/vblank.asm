INCLUDE "hardware.inc"

SECTION "VBlankVars", WRAM0
wVBlankCount:: db

SECTION "VBlankFunc", ROM0
WaitForOneVBlank::
    ld a, 1
    ld [wVBlankCount], a

; Wait for as many VBlank as wVBlankCount has
WaitForVBlankFunc::
WaitForVBlankFunc_Loop::
    ld a, [rLY]
    cp 144
    jp c, WaitForVBlankFunc_Loop

    ld a, [wVBlankCount]
    sub 1
    ld [wVBlankCount], a

    ret z

WaitForVBlankFunc_Loop2::
    ld a, [rLY]
    cp 144
    jp nc, WaitForVBlankFunc_Loop2
    jp WaitForVBlankFunc_Loop