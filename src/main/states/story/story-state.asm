INCLUDE "hardware.inc"
INCLUDE "src/main/utils/macros/text.inc"

SECTION "StoryState", ROM0
InitStoryState::
    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON | LCDCF_OBJ16
    ld [rLCDC], a

    ret

UpdateStoryState::
    ld de, $9821
    ld hl, Story.L1
    call DrawText_WithTypewriter

    ld de, $9861
    ld hl, Story.L2
    call DrawText_WithTypewriter

    ld de, $98A1
    ld hl, Story.L3
    call DrawText_WithTypewriter

    ld de, $98E1
    ld hl, Story.L4
    call DrawText_WithTypewriter

    ld a, PADF_A
    ld [mWaitKey], a
    call WaitForKeyFunc

    call ClearBackground

    ld de, $9821
    ld hl, Story.L5
    call DrawText_WithTypewriter

    ld de, $9861
    ld hl, Story.L6
    call DrawText_WithTypewriter

    ld de, $98A1
    ld hl, Story.L7
    call DrawText_WithTypewriter

    ld a, PADF_A
    ld [mWaitKey], a
    call WaitForKeyFunc

    ld a, 2
    ld [wGameState], a
    jp NextGameState

Story:
    .L1 db "the galactic empire", 255
    .L2 db "rules the galaxy", 255
    .L3 db "with an iron", 255
    .L4 db "fist.", 255
    .L5 db "the rebel force", 255
    .L6 db "remain hopeful of", 255
    .L7 db "freedoms light", 255