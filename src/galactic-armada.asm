INCLUDE "hardware.inc"

SECTION "GameVars", WRAM0
wLastKeys:: db
wCurKeys:: db
wNewKeys:: db
wGameState:: db

SECTION "Header", ROM0[$100]
    jp EntryPoint
    ds $150 - @, 0

EntryPoint:
    xor a

    ; Disable Sound
    ld [rNR52], a
    ld [wGameState], a

    ; Init Sprites
    call WaitForOneVBlank
    call InitSprObjLib

    ; Disable Screen
    xor a
    ld [rLCDC], a

    ; Load and Init Screen
    call LoadTextFontIntoVRAM
    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON | LCDCF_OBJ16 | LCDCF_WINON | LCDCF_WIN9C00
    ld [rLCDC], a

    ld a, %11100100
    ld [rBGP], a
    ld [rOBP0], a

NextGameState::
    call WaitForOneVBlank
    call ClearBackground

    ; Turn LCD off
    xor a
    ld [rLCDC], a
    ld [rSCX], a
    ld [rSCY], a
    ld [rWX], a
    ld [rWY], a

    ; Cleanup
    ; call DisableInterrupts
    ; call ClearAllSprites

    ; Init new State

    ; Gameplay
    ld a, [wGameState]
    cp 2
    call z, InitGameplayState

    ; Story
    ld a, [wGameState]
    cp 1
    call z, InitStoryState

    ; Menu
    ld a, [wGameState]
    cp 0
    call z, InitTitleScreenState

    ; Update next state
    ld a, [wGameState]

    cp 2 ; Gameplay
    jp z, UpdateGameplayState

    cp 1 ; Story
    jp z, UpdateStoryState

    jp UpdateTitleScreenState ; Menu