SECTION "Input Vars", WRAM0
mWaitKey:: db

SECTION "Input Utils", ROM0
WaitForKeyFunc::
    push bc

WaitForKeyFunc_Loop:
    ld a, [wCurKeys]
    ld [wLastKeys], a

    call Input

    ld a, [mWaitKey]
    ld b, a
    ld a, [wCurKeys]

    and a, b
    jp z, WaitForKeyFunc_NotPressed

    ld a, [wLastKeys]
    and a, b
    jp nz, WaitForKeyFunc_NotPressed

    pop bc
    ret

WaitForKeyFunc_NotPressed:
    call WaitForOneVBlank
    jp WaitForKeyFunc_Loop