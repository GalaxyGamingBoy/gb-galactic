INCLUDE "src/main/utils/constants.inc"

SECTION "Metasprite Vars", WRAM0
wMetaspriteAddress:: dw
wMetaspriteX:: db
wMetaspriteY:: db

SECTION "Metasprites", ROM0

; Draws a metasprite
; Registers used:
; - b: mspr y
; - c: mspr x
; - d: mspr tile
; - e: mspr flag
DrawMetasprites::
    ; Setup vars

    ; Store metasprite addr to hl
    ld a, [wMetaspriteAddress + 0]
    ld l, a
    ld a, [wMetaspriteAddress + 1]
    ld h, a

    ; Load y
    ld a, [hli]
    ld b, a

    ; If y == 128 ret
    ld a, b
    cp 128
    ret z

    ; Increment mspr y by y
    ld a, [wMetaspriteY]
    add b
    ld [wMetaspriteY], a

    ; Load x
    ld a, [hli]
    ld c, a

    ; Increment mspr x by x
    ld a, [wMetaspriteX]
    add c
    ld [wMetaspriteX], a

    ; Load tile
    ld a, [hli]
    ld d, a

    ; Load flag
    ld a, [hli]
    ld e, a

    ; Draw
    ld a, [wLastOAMAddress]
    ld l, a
    ld a, HIGH(wShadowOAM)
    ld h, a

    ld a, [wMetaspriteY]
    ld [hli], a ; OAM OBJ Y
    ld a, [wMetaspriteX]
    ld [hli], a ; OAM OBJ X
    ld a, d
    ld [hli], a ; OAM OBJ TILE
    ld a, e
    ld [hli], a ; OAM OBJ FLAG

    call NextOAMSprite

    ld a, [wMetaspriteAddress]
    add a, METASPRITE_BYTES_COUNT
    ld [wMetaspriteAddress], a

    ld a, [wMetaspriteAddress + 1]
    adc 0
    ld [wMetaspriteAddress + 1], a

    jp DrawMetasprites