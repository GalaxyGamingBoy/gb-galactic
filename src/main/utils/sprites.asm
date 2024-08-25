INCLUDE "hardware.inc"

SECTION "Sprites Vars", WRAM0
wLastOAMAddress:: dw
; wSpritesUsed:: db

SECTION "Sprites", ROM0
ClearAllSprites::
    xor a
    ld b, OAM_COUNT * sizeof_OAM_ATTRS
    ld hl, wShadowOAM

ClearOAMLoop::
    ld [hli], a
    
    dec b
    jp nz, ClearOAMLoop
    
    ; xor a
    ; ld [wSpritesUsed], a

    ld a, HIGH(wShadowOAM)
    jp hOAMDMA

ClearRemainingSprites::
ClearRemainingSprites_Loop::
    ld a, [wLastOAMAddress]
    ld l, a

    ld a, HIGH(wShadowOAM)
    ld h, a

    ld a, l
    cp 160
    ret nc

    xor a
    ld [hli], a
    ld [hld], a

    ; // FIXME: Possible Wasteful Code
    ld a, l
    add 4
    ld l, a

    call NextOAMSprite
    jp ClearRemainingSprites_Loop

ResetOAMSpriteAddress::
    xor a
    ; ld [wSpritesUsed], a

    ld a, LOW(wShadowOAM)
    ld [wLastOAMAddress], a

    ld a, HIGH(wShadowOAM)
    ld [wLastOAMAddress + 1], a

    ret

NextOAMSprite::
    ; ld a, [wSpritesUsed]
    ; inc a
    ; ld [wSpritesUsed], a

    ld a, [wLastOAMAddress]
    add sizeof_OAM_ATTRS
    ld [wLastOAMAddress], a

    ld a, HIGH(wShadowOAM); TODO: POTENTIAL WASTEFUL CODE
    ld [wLastOAMAddress + 1], a

    ret