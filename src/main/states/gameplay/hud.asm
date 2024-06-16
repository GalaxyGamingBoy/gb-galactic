INCLUDE "hardware.inc"

SECTION "Gameplay HUD", ROM0
IncreaseScore::
    ld c, 0
    ld hl, wScore + 5

IncreaseScore_Loop:
    ld a, [hl]
    inc a
    ld [hl], a

    cp 9
    ret c

IncreaseScore_Next:
    inc c
    ld a, c

    cp 6
    ret z

    xor a
    ; ld [hl], a
    ld [hld], a

    jp IncreaseScore_Loop

DrawScore::
    ld c, 6
    ld hl, wScore
    ld de, $9C06

DrawScore_Loop:
    ld a, [hli]
    add 10
    ld [de], a

    dec c
    ret z

    inc de
    jp DrawScore_Loop

DrawLives::
    ld hl, wLives
    ld de, $9C13

    ld a, [hl]
    add 10
    ld [de], a

    ret