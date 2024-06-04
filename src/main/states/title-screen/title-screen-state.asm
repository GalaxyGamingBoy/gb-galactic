INCLUDE "hardware.inc"
INCLUDE "src/main/utils/macros/text.inc"

SECTION "TitleScreenState", ROM0
wPressPlayText:: db "press a to play", 255

titleScreenTile: INCBIN "src/gen/bgs/title-screen.2bpp"
titleScreenTileEnd:

titleScreenTilemap: INCBIN "src/gen/bgs/title-screen.tilemap"
titleScreenTilemapEnd:

InitTitleScreenState::
    call DrawTitleScreen

    ld de, $99C3
    ld hl, wPressPlayText
    call DrawTextTilesLoop

    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON | LCDCF_OBJ16
    ld [rLCDC], a

    ret

DrawTitleScreen::
    ld de, titleScreenTile
    ld hl, _VRAM + $1340
    ld bc, titleScreenTileEnd - titleScreenTile
    call CopyDEIntoMemoryAtHL

    ld de, titleScreenTilemap
    ld hl, _SCRN0
    ld bc, titleScreenTilemapEnd - titleScreenTilemap
    jp CopyDEIntoMemoryAtHL_W52Offset

UpdateTitleScreenState::
    ld a, PADF_A
    ld [mWaitKey], a

    call WaitForKeyFunc

    ld a, 1
    ld [wGameState], a
    jp NextGameState