INCLUDE "hardware.inc"
INCLUDE "src/main/utils/macros/text.inc"

SECTION "Background Vars", WRAM0
wBackgroundScroll:: dw

SECTION "Gameplay Background", ROM0
starfieldMap: INCBIN "src/gen/bgs/star-field.tilemap"
starfieldMapEnd:

starfieldTile: INCBIN "src/gen/bgs/star-field.2bpp"
starfieldTileEnd:

InitBackground::
    ld de, starfieldTile
    ld hl, _VRAM + $1340
    ld bc, starfieldTileEnd - starfieldTile
    call CopyDEIntoMemoryAtHL

    ld de, starfieldMap
    ld hl, $9800
    ld bc, starfieldMapEnd - starfieldMap
    call CopyDEIntoMemoryAtHL_W52Offset

    xor a
    ld [wBackgroundScroll], a
    ld [wBackgroundScroll + 1], a
    ret

UpdateBackground::
    ld a, [wBackgroundScroll]
    add a, 5
    ld c, a
    ld [wBackgroundScroll], a

    ld a, [wBackgroundScroll + 1]
    adc 0
    ld b, a
    ld [wBackgroundScroll + 1], a

    srl b
    rr c
    srl b
    rr c
    srl b
    rr c
    srl b
    rr c

    ld a, c
    ld [rSCY], a
    ret