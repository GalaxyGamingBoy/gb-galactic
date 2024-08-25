INCLUDE "src/main/utils/constants.inc"
INCLUDe "hardware.inc"

SECTION "Collisions Vars", WRAM0
wResult:: db
wSize:: db
wObj1Val:: db
wObj2Val:: db

SECTION "Collision Utils", ROM0
CheckObjPositionDiff::
    ld a, [wObj1Val]
    ld e, a
    ld a, [wObj2Val]
    ld b, a

    ld a, [wSize]
    ld d, a

    ld a, e
    add d
    cp b

    jp c, CheckObjPositionDiff_Fail

    ld a, e
    sub d
    cp b
    
    jp nc, CheckObjPositionDiff_Fail

    ld a, 1
    ld [wResult], a
    ret

CheckObjPositionDiff_Fail::
    ld a, 0
    ld [wResult], a
    ret