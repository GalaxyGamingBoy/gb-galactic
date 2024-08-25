SECTION "Enemy Player Collision", ROM0
CheckEnemyPlayerCollision::
    ; Check X
    ld a, [wPlayerPositionX]
    ld d, a
    ld a, [wPlayerPositionX + 1]
    ld e, a

    srl e
    rr d
    srl e
    rr d
    srl e
    rr d
    srl e
    rr d

    ld a, [wCurrEnemyX]
    ld [wObj1Val], a
    ld a, d
    ld [wObj2Val], a

    ld a, 16
    ld [wSize], a

    call CheckObjPositionDiff

    ld a, [wResult]
    and a
    jp z, NoCollisionWithPlayer

    ; Check Y
    ld a, [wPlayerPositionY]
    ld d, a
    ld a, [wPlayerPositionY + 1]
    ld e, a

    srl e
    rr d
    srl e
    rr d
    srl e
    rr d
    srl e
    rr d

    ld a, [wCurrEnemyY]
    ld [wObj1Val], a
    ld a, d
    ld [wObj2Val], a

    ld a, 16
    ld [wSize], a

    call CheckObjPositionDiff

    ld a, [wResult]
    and a
    jp z, NoCollisionWithPlayer

    ld a, 1
    ld [wResult], a
    ret

NoCollisionWithPlayer::
    ld a, 0
    ld [wResult], a
    ret