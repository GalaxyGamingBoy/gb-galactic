SECTION "Text Utils", ROM0

textFontTile: INCBIN "src/gen/bgs/text-font.2bpp"
textFontTileEnd:

LoadTextFontIntoVRAM::
    ld de, textFontTile
    ld hl, $9000
    ld bc, textFontTileEnd - textFontTile

    jp CopyDEIntoMemoryAtHL

; Draws text. `de`: Destination Location, `hl`: Text to copy
DrawTextTilesLoop::
    ld a, [hl]
    cp 255
    ret z

    ld a, [hli]
    ld [de], a

    inc de

    jp DrawTextTilesLoop

; Draws text. `de`: Destination Location, `hl`: Text to copy
DrawText_WithTypewriter::
    ld a, 3
    ld [wVBlankCount], a
    call WaitForVBlankFunc

    ld a, [hl]
    cp 255
    ret z

    ld a, [hli]
    ld [de], a

    inc de
    
    jp DrawText_WithTypewriter