SECTION "Text Utils", ROM0

textFontTile: INCBIN "src/gen/bgs/text-font.2bpp"
textFontTileEnd:

LoadTextFontIntoVRAM::
    ld de, textFontTile
    ld hl, $9000
    ld bc, textFontTileEnd - textFontTile

    jp CopyDEIntoMemoryAtHL

DrawTextTilesLoop::
    ld a, [hl]
    cp 255
    ret z

    ld a, [hl]
    ld [de], a

    inc hl
    inc de

    jp DrawTextTilesLoop