INCLUDE "hardware.inc"
INCLUDE "src/main/utils/constants.inc"

SECTION "Bullet Vars", WRAM0
wSpawnBullet: db
wActiveBulletCounter:: db
wUpdateBulletCounter:: db
wBullets:: ds MAX_BULLET_COUNT * PER_BULLET_BYTES_COUNT

SECTION "Bullets", ROM0
bulletMetasprite::
    .mspr1   db 0, 0, 8, 0
    .msprEnd db 128

bulletTile:: INCBIN "src/gen/sprs/bullet.2bpp"
bulletTileEnd::

; @r8 b: Bullet Counter
InitBullets::
    xor a
    ld [wSpawnBullet], a

    ld de, bulletTile
    ld hl, BULLET_TILES_START
    ld bc, bulletTileEnd - bulletTile
    call CopyDEIntoMemoryAtHL

    xor a
    ld [wActiveBulletCounter], a
    ld b, a

    ld hl, wBullets
    InitBullets_Loop:
    xor a
    ld [hl], a

    ld a, l
    add PER_BULLET_BYTES_COUNT
    ld l, a

    ld a, h
    adc 0
    ld h, a

    ld a, b
    inc a
    ld b, a

    cp MAX_BULLET_COUNT
    ret z

    jp InitBullets_Loop

UpdateBullets::
    ld a, [wSpawnBullet]
    ld b, a
    ld a, [wActiveBulletCounter]

    or a, b
    ret z

    xor a
    ld [wUpdateBulletCounter], a

    ; // FIXME: Possible wasteful code - Might be allowed to do, `ld hl, wBullets`
    ld l, LOW(wBullets)
    ld h, HIGH(wBullets)

    jp UpdateBullets_PerBullet

UpdateBullets_PerBullet:
    ld a, [hl]
    and a
    jp nz, UpdateBullets_PerBullet_Normal

    ld a, [wSpawnBullet]
    and a
    jp z, UpdateBullets_Loop

UpdateBullets_PerBullet_SpawnDeactivatedBullet:
    xor a
    ld [wSpawnBullet], a

    ld a, [wActiveBulletCounter]
    inc a
    ld [wActiveBulletCounter], a

    push hl

    ld a, 1
    ld [hli], a

    ld a, [wPlayerPositionX]
    ld b, a
    ld a, [wPlayerPositionX + 1]
    ld d, a

    srl d
    rr b
    srl d
    rr b
    srl d
    rr b
    srl d
    rr b

    ld a, b
    ld [hli], a

    ld a, [wPlayerPositionY]
    ld [hli], a
    ld a, [wPlayerPositionY + 1]
    ld [hl], a ; // FIXME: [hli] -> [hl]

    pop hl
UpdateBullets_PerBullet_Normal:
    push hl
    inc hl

    ld a, [hli]
    ld b, a

    ld a, [hl]
    sub BULLET_MOVE_SPEED
    ld [hli], a
    ld c, a

    ld a, [hl]
    sbc 0
    ld [hl], a
    ld d, a

    srl d
    rr c
    srl d
    rr c
    srl d
    rr c
    srl d
    rr c

    ld a, c
    cp 178 
    pop hl
    jp nc, UpdateBUllets_DeactivateOutOfBounds
    push hl

    ld a, LOW(bulletMetasprite)
    ld [wMetaspriteAddress], a
    ld a, HIGH(bulletMetasprite)
    ld [wMetaspriteAddress + 1], a

    ld a, b
    ld [wMetaspriteX], a

    ld a, c
    ld [wMetaspriteY], a
    call DrawMetasprites

    pop hl
    jp UpdateBullets_Loop

UpdateBUllets_DeactivateOutOfBounds:
    xor a
    ld [hl], a

    ld a, [wActiveBulletCounter]
    dec a
    ld [wActiveBulletCounter], a
    jp UpdateBullets_Loop

UpdateBullets_Loop:
    ld a, [wUpdateBulletCounter]
    inc a
    ld [wUpdateBulletCounter], a
    
    ld a, [wUpdateBulletCounter]
    cp MAX_BULLET_COUNT
    ret nc

    ld a, l
    add PER_BULLET_BYTES_COUNT
    ld l, a
    ld a, h
    adc 0
    ld h, a

    jp UpdateBullets_PerBullet

FireNextBullet::
    ld a, [wActiveBulletCounter]
    cp MAX_BULLET_COUNT
    ret nc

    ld a, 1
    ld [wSpawnBullet], a
    ret
