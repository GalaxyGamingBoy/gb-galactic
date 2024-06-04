INCLUDE "../../utils/hardware.inc"
INCLUDE "src/main/utils/macros/text-macros.inc"

SECTION "TitleScreenState", ROM0
wPressPlayText:: db "press a to play", 255

titleScreenTile: INCBIN "src/gen/bgs/title-screen.2bpp"
titleScreenTileEnd:

titleScreenTilemap: INCBIN "src/gen/bgs/title-screen.tilemap"
titleScreenTilemapEnd:

InitTitleScreenState::
    ; call DrawTitleScreen

    ld de, $99C3
    ld hl, wPressPlayText

    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON | LCDCF_OBJ16
    ld [rLCDC], a

    ret