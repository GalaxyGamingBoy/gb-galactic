INCLUDE "hardware.inc"
INCLUDE "src/main/utils/macros/text.inc"

SECTION "Gameplay Vars", WRAM0
wScore:: ds 6
wLives:: db

SECTION "Gameplay State", ROM0
wScoreText:: db "score", 255
wLivesText:: db "lives", 255

InitGameplayState::
    ld a, 3
    ld [wLives], a
    
    xor a
    ld [wScore], a
    ld [wScore + 1], a
    ld [wScore + 2], a
    ld [wScore + 3], a
    ld [wScore + 4], a
    ld [wScore + 5], a

    call InitBackground
    call InitPlayer
    call InitBullets
    call InitEnemies ; // TODO

    call InitStatInterrupts

    ld de, $9C00
    ld hl, wScoreText
    call DrawTextTilesLoop

    ld de, $9C0D
    ld hl, wLivesText
    call DrawTextTilesLoop

    call DrawScore
    call DrawLives

    xor a
    ld [rWY], a

    ld a, 7
    ld [rWX], a

    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON | LCDCF_OBJ16 | LCDCF_WINON | LCDCF_WIN9C00 | LCDCF_BG9800
    ld [rLCDC], a

    ret

UpdateGameplayState::
    ld a, [wCurKeys]
    ld [wLastKeys], a
    call Input

    call ResetShadowOAM
    call ResetOAMSpriteAddress

    call UpdatePlayer
    call UpdateEnemies ; // TODO
    call UpdateBullets
    call UpdateBackground

    call ClearRemainingSprites

    ld a, [wLives]
    cp 250 ; // TODO:  [wLives] (def: 3) - 250, To not overflow must be 0 - 250 = 250. Maybe value $FC(252) might be more concrete.
    jp nc, EndGameplay

    call WaitForOneVBlank
    ld a, HIGH(wShadowOAM)
    call hOAMDMA
    call WaitForOneVBlank

    jp UpdateGameplayState

EndGameplay:
    ld a, 0
    ld [wGameState], a
    jp NextGameState