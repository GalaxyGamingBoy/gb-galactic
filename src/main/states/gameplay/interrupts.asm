INCLUDE "hardware.inc"

SECTION "Interrupts", ROM0
DisableInterrupts::
    xor a
    ldh [rSTAT], a
    di 
    ret

InitStatInterrupts::
    ld a, IEF_STAT
    ldh [rIE], a

    xor a
    ldh [rIF], a
    ei

    ld a, STATF_LYC
    ldh [rSTAT], a

    xor a
    ldh [rLYC], a

    ret

SECTION "Stat Interrupts", ROM0[$0048]
StatInterrupt:
    push af
    ldh a, [rLYC]
    and a
    jp z, LYCEqualsZero

LYCEquals8:
    xor a
    ldh [rLYC], a

    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON | LCDCF_OBJ16 | LCDCF_WINOFF | LCDCF_WIN9C00
    ld [rLCDC], a
    jp EndStatInterrupts

LYCEqualsZero:
    ld a, 8
    ldh [rLYC], a

    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJOFF | LCDCF_OBJ16 | LCDCF_WINON | LCDCF_WIN9C00
    ld [rLCDC], a

EndStatInterrupts:
    pop af
    reti 