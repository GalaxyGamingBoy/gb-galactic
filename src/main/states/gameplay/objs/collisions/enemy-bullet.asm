INCLUDE "hardware.inc"
INCLUDE "src/main/utils/constants.inc"

SECTION "EnemyBullet Vars", WRAM0
wEnemyBulletCollisionCounter: db
wBulletAddress: dw

SECTION "EnemyBullet", ROM0
CheckCurrentEnemyAgainstBullets::
    ld a, l
    ld [wUpdateEnemiesCurrEnemyAddr], a
    ld a, h
    ld [wUpdateEnemiesCurrEnemyAddr + 1], a

    xor a
    ld [wEnemyBulletCollisionCounter], a

    ld a, LOW(wBullets)
    ld l, a
    ld a, HIGH(wBullets)
    ld h, a

    jp CheckCurrentEnemyAgainstBullets_PerBullet

CheckCurrentEnemyAgainstBullets_Loop:
    ld a, [wEnemyBulletCollisionCounter]
    inc a
    ld [wEnemyBulletCollisionCounter], a

    cp MAX_BULLET_COUNT
    ret z

    ld a, l
    add PER_BULLET_BYTES_COUNT
    ld l, a
    ld a, h
    adc 0
    ld h, a

CheckCurrentEnemyAgainstBullets_PerBullet:
    ld a, [hl]
    cp 1
    jp nz, CheckCurrentEnemyAgainstBullets_Loop

CheckCurrentEnemyAgainstBullets_Check_X_Overlap:
    push hl
    inc hl

    ld a, [hli]
    ld b, a

    push hl ; TODO: POTENTIAL UNUSED PUSH

    ld a, b
    ld [wObj1Val], a

    ld a, [wCurrEnemyX]
    add 4
    ld [wObj2Val], a

    ld a, 8
    ld [wSize], a

    call CheckObjPositionDiff

    ld a, [wResult]
    and a
    jp z, CheckCurrentEnemyAgainstBullets_Check_X_Overlap_Fail

    pop hl

    jp CheckCurrentEnemyAgainstBullets_PerBullet_Y_Overlap

CheckCurrentEnemyAgainstBullets_Check_X_Overlap_Fail:
    pop hl
    pop hl

    jp CheckCurrentEnemyAgainstBullets_Loop

CheckCurrentEnemyAgainstBullets_PerBullet_Y_Overlap:
    ld a, [hli]
    ld b, a

    ld a, [hli]
    ld c, a

    srl c
    rr b
    srl c
    rr b
    srl c
    rr b
    srl c
    rr b

    pop hl
    push hl

    ld a, b
    ld [wObj1Val], a

    ld a, [wCurrEnemyY]
    ld [wObj2Val], a

    ld a, 16
    ld [wSize], a

    call CheckObjPositionDiff

    pop hl
    
    ld a, [wResult]
    and a
    jp z, CheckCurrentEnemyAgainstBullets_Loop
    jp CheckCurrentEnemyAgainstBullets_PerBullet_Collision

CheckCurrentEnemyAgainstBullets_PerBullet_Collision:
    xor a
    ld [hli], a
    ld [hl], a

    ld a, [wUpdateEnemiesCurrEnemyAddr + 0]
    ld l, a
    ld a, [wUpdateEnemiesCurrEnemyAddr + 1]
    ld h, a

    xor a
    ld [hli], a
    ld [hl], a
    
    call IncreaseScore
    call DrawScore

    ld a, [wActiveEnemyCounter]
    dec a
    ld [wActiveEnemyCounter], a

    ld a, [wActiveBulletCounter]
    dec a
    ld [wActiveBulletCounter], a

    ret