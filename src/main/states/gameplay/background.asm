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
    ld hl, $9340
    ld bc, starfieldTileEnd - starfieldTile
    call CopyDEIntoMemoryAtHL

    ld de, starfieldMap
    ld hl, $9800
    ld bc, starfieldMapEnd - starfieldMap
    call CopyDEIntoMemoryAtHL

    xor a
    ld [wBackgroundScroll], a
    ld [wBackgroundScroll + 1], a
    ret

UpdateBackground::
    ld a, [wBackgroundScroll]
    add a, 5
    ld b, a
    ld [wBackgroundScroll], a

    ld a, [wBackgroundScroll + 1]
    adc 0
    ld c, a
    ld [wBackgroundScroll + 1], a

    srl c
    rr b
    srl c
    rr b
    srl c
    rr b
    srl c
    rr b

    ld a, b
    ld [rSCY], a
    ret