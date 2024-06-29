INCLUDE "hardware.inc"
INCLUDE "src/main/utils/constants.inc"

SECTION "Player Vars", WRAM0
wPlayerPositionX:: dw
wPlayerPositionY:: dw
mPlayerFlash: dw

SECTION "Player", ROM0
playerShipTile: INCBIN "src/gen/sprs/player-ship.2bpp"
playerShipTileEnd:

playerTestMetasprite::
.mspr1   db 0, 0, 0, 0
.mspr2   db 0, 8, 2, 0
.msprEnd db 128

InitPlayer::
    xor a
    ld [mPlayerFlash], a
    ld [mPlayerFlash + 1], a

    ld [wPlayerPositionX], a
    ld [wPlayerPositionY], a

    ld a, 5
    ld [wPlayerPositionX + 1], a
    ld [wPlayerPositionY + 1], a

CopyPlayerTileIntoVRAM:
    ld de, playerShipTile
    ld hl, PLAYER_TILES_START
    ld bc, playerShipTileEnd - playerShipTile
    call CopyDEIntoMemoryAtHL
    ret

UpdatePlayer::
UpdatePlayer_HandleInput:
    ld a, [wCurKeys]
    and PADF_UP
    call nz, MoveUp

    ld a, [wCurKeys]
    and PADF_DOWN
    call nz, MoveDown

    ld a, [wCurKeys]
    and PADF_LEFT
    call nz, MoveLeft

    ld a, [wCurKeys]
    and PADF_RIGHT
    call nz, MoveRight

    ld a, [wCurKeys]
    and PADF_A
    call nz, TryShoot

    ld a, [mPlayerFlash]
    ld c, a

    ld a, [mPlayerFlash + 1]
    ld b, a

UpdatePlayer_UpdateSprite_CheckFlashing:
    ld a, c
    or b
    jp z, UpdatePlayer_UpdateSprite

    ; Decr bc
    ld a, c
    sub 5
    ld c, a

    ld a, b
    sbc 0
    ld b, a

UpdatePlayer_UpdateSprite_DecreaseFlashing:
    ld a, c
    ld [mPlayerFlash], a
    ld a, b
    ld [mPlayerFlash + 1], a

    ; Downscale integer
    srl b
    rr c
    srl b
    rr c
    srl b
    rr c
    srl b
    rr c

    ld a, c
    cp 5
    jp c, UpdatePlayer_UpdateSprite_StopFlashing
    
    bit 0, c
    jp z, UpdatePlayer_UpdateSprite

UpdatePlayer_UpdateSprite_Flashing:
    ret

UpdatePlayer_UpdateSprite_StopFlashing:
    xor a
    ld [mPlayerFlash], a
    ld [mPlayerFlash + 1], a

UpdatePlayer_UpdateSprite:
    ld a, [wPlayerPositionX]
    ld b, a
    ld a, [wPlayerPositionX + 1]
    ld d, a

    ; Downscale integer
    srl d
    rr b
    srl d
    rr b
    srl d
    rr b
    srl d
    rr b

    ld a, [wPlayerPositionY]
    ld c, a
    ld a, [wPlayerPositionY + 1]
    ld e, a

    ; Downscale integer
    srl e
    rr c
    srl e
    rr c
    srl e
    rr c
    srl e
    rr c

    ld a, LOW(playerTestMetasprite)
    ld [wMetaspriteAddress], a
    ld a, HIGH(playerTestMetasprite)
    ld [wMetaspriteAddress + 1], a

    ld a, b
    ld [wMetaspriteX], a

    ld a, c
    ld [wMetaspriteY], a

    call DrawMetasprites
    ret

DamagePlayer::
    xor a
    ld [mPlayerFlash], a
    inc a
    ld [mPlayerFlash + 1], a

    ld a, [wLives]
    dec a
    ld [wLives], a

    ret

; Shoot
TryShoot:
    ld a, [wLastKeys]
    and PADF_A
    ret nz

    jp FireNextBullet

; Move Player
MoveUp:
    ld a, [wPlayerPositionY]
    sub PLAYER_MOVE_SPEED
    ld [wPlayerPositionY], a

    ld a, [wPlayerPositionY + 1]
    sbc 0
    ld [wPlayerPositionY + 1], a
    ret

MoveDown:
    ld a, [wPlayerPositionY]
    add PLAYER_MOVE_SPEED
    ld [wPlayerPositionY], a

    ld a, [wPlayerPositionY + 1]
    adc 0
    ld [wPlayerPositionY + 1], a
    ret

MoveLeft:
    ld a, [wPlayerPositionX]
    sub PLAYER_MOVE_SPEED
    ld [wPlayerPositionX], a

    ld a, [wPlayerPositionX + 1]
    sbc 0
    ld [wPlayerPositionX + 1], a
    ret

MoveRight:
    ld a, [wPlayerPositionX]
    add PLAYER_MOVE_SPEED
    ld [wPlayerPositionX], a

    ld a, [wPlayerPositionX + 1]
    adc 0
    ld [wPlayerPositionX + 1], a
    ret
    