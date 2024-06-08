INCLUDE "hardware.inc"

SECTION "background", ROM0
ClearBackground::
    xor a
    ld [rLCDC], a

    ld bc, $400
    ld hl, _SCRN0

ClearBackgroundLoop:
    xor a
    ld [hli], a

    dec bc
    ld a, b
    or a, c

    jp nz, ClearBackgroundLoop

    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON | LCDCF_OBJ16
    ld [rLCDC], a

    ret