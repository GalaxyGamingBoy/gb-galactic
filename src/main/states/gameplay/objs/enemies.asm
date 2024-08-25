INCLUDE "hardware.inc"
INCLUDE "src/main/utils/constants.inc"

SECTION "Enemy Vars", WRAM0
wCurrEnemyX:: db
wCurrEnemyY:: db

wSpawnCounter: db
wNextEnemyX: db
wActiveEnemyCounter:: db
wUpdateEnemiesCounter: db
wUpdateEnemiesCurrEnemyAddr:: dw

wEnemies:: ds MAX_ENEMY_COUNT * PER_ENEMY_BYTES_COUNT

SECTION "Enemy", ROM0
enemyShipTile:: INCBIN "src/gen/sprs/enemy-ship.2bpp"
enemyShipTileEnd::

enemyShipMspr::
.mspr1   db 0, 0, 4, 0
.mspr2   db 0, 8, 6, 0
.msprEnd db 128

InitEnemies::
    ld de, enemyShipTile
    ld hl, ENEMY_TILES_START
    ld bc, enemyShipTileEnd - enemyShipTile
    call CopyDEIntoMemoryAtHL

    xor a
    ld [wSpawnCounter], a
    ld [wActiveEnemyCounter], a
    ld [wNextEnemyX], a

    ld b, a
    ld hl, wEnemies

InitEnemies_Loop:
    ld [hl], 0 ; Set enemy as inactive

    ld a, l
    add PER_ENEMY_BYTES_COUNT
    ld l, a
    ld a, h
    adc 0
    ld h, a

    inc b
    ld a, b

    cp MAX_ENEMY_COUNT
    ret z

    jp InitEnemies_Loop

UpdateEnemies::
    call TryToSpawnEnemies

    ld a, [wNextEnemyX]
    ld b, a
    ld a, [wActiveEnemyCounter]

    or a, b
    and a, a ; // FIXME: Potential wasteful code
    ret z

    xor a
    ld [wUpdateEnemiesCounter], a

    ld a, LOW(wEnemies)
    ld l, a
    ld a, HIGH(wEnemies)
    ld h, a

    jp UpdateEnemies_PerEnemy

UpdateEnemies_Loop:
    ld a, [wUpdateEnemiesCounter]
    inc a
    ld [wUpdateEnemiesCounter], a

    cp MAX_ENEMY_COUNT
    ret nc

    ld a, l
    add PER_ENEMY_BYTES_COUNT
    ld l, a
    ld a, h
    adc 0
    ld h, a

UpdateEnemies_PerEnemy:
    ld a, [hl]
    and a
    jp nz, UpdateEnemies_PerEnemy_Update

UpdateEnemies_SpawnNewEntry:
    ld a, [wNextEnemyX]
    and a
    jp z, UpdateEnemies_Loop

    ; Spawn new enemy
    push hl

    ld a, 1
    ld [hli], a

    ld a, [wNextEnemyX]
    ld [hli], a

    xor a
    ld [hli], a
    ld [hli], a
    ld [wNextEnemyX], a

    ld a, [wActiveEnemyCounter]
    inc a
    ld [wActiveEnemyCounter], a

    pop hl

UpdateEnemies_PerEnemy_Update:
    push hl

    ; Load move speed to e register
    ld bc, enemy_speed
    add hl, bc
    ld a, [hl]
    ld e, a

    pop hl
    push hl
    inc hl

    ; Load x
    ld a, [hli]
    ld b, a
    ld [wCurrEnemyX], a

    ; Load y
    ld a, [hl]
    add ENEMY_MOVE_SPEED
    ld [hli], a
    ld c, a

    ld a, [hl]
    adc 0
    ld [hl], a
    ld d, a

    pop hl

    srl d
    rr c
    srl d
    rr c
    srl d
    rr c
    srl d
    rr c

    ld a, c
    ld [wCurrEnemyY], a

UpdateEnemies_PerEnemy_CheckPlayerCollision:
    push hl
    call CheckCurrentEnemyAgainstBullets
    call CheckEnemyPlayerCollision
    pop hl

    ld a, [wResult]
    and a
    jp z, UpdateEnemies_NoCollisionWithPlayer

    push hl
    call DamagePlayer
    call DrawLives
    pop hl

UpdateEnemies_DeActivateEnemy:
    xor a
    ld [hl], a
    
    ld a, [wActiveEnemyCounter]
    dec a
    ld [wActiveEnemyCounter], a

    jp UpdateEnemies_Loop

UpdateEnemies_NoCollisionWithPlayer::
    ld a, [wCurrEnemyY]
    cp 160
    jp nc, UpdateEnemies_DeActivateEnemy

    push hl
    ld a, LOW(enemyShipMspr)
    ld [wMetaspriteAddress + 0], a
    ld a, HIGH(enemyShipMspr)
    ld [wMetaspriteAddress + 1], a

    ld a, [wCurrEnemyX]
    ld [wMetaspriteX], a
    ld a, [wCurrEnemyY]
    ld [wMetaspriteY], a
    call DrawMetasprites
    pop hl

    jp UpdateEnemies_Loop

TryToSpawnEnemies::
    ld a, [wSpawnCounter]
    inc a
    ld [wSpawnCounter], a

    cp ENEMY_SPAWN_DELAY_MAX
    ret c

    ld a, [wNextEnemyX]
    cp 0
    ret nz

    ld a, [wActiveEnemyCounter]
    cp MAX_ENEMY_COUNT
    ret nc

GetSpawnPosition:
    call rand

    ld a, b
    cp 150
    ret nc

    ld a, b
    cp 24
    ret c

    xor a
    ld [wSpawnCounter], a

    ld a, b
    ld [wNextEnemyX], a

    ret