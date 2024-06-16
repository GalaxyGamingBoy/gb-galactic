INCLUDE "hardware.inc"

DEF MAX_ENEMY_COUNT EQU 10
DEF ENEMY_SPAWN_DELAY_MAX EQU 70
DEF ENEMY_MOVE_SPEED EQU 11

DEF MAX_BULLET_COUNT EQU 5
DEF BULLET_MOVE_SPEED EQU 20

DEF PLAYER_MOBE_SPEED EQU 15
DEF PADDLE_Y_POSITION EQU 136

RSRESET
DEF metasprite_y            RB 1
DEF metasprite_x            RB 1
DEF metasprite_tile         RB 1
DEF metasprite_flag         RB 1
DEF METASPRITE_BYTES_COUNT  RB 0

RSRESET
DEF enemy_active          RB 1
DEF enemy_x               RB 1
DEF emeny_yLOW            RB 1
DEF enemy_yHIGH           RB 1
DEF enemy_speed           RB 1
DEF enemy_health          RB 1
DEF PER_ENEMY_BYTES_COUNT RB 0

RSRESET
DEF bullet_active           RB 1
DEF bullet_x                RB 1
DEF bullet_yLOW             RB 1
DEF bullet_yHIGH            RB 1
DEF PER_BULLET_BYTES_COUNT  RB 0

RSRESET
DEF spriteTilesStart    RB _VRAM
DEF PLAYER_TILES_START  RB 4 * 16
DEF ENEMY_TILES_START   RB 4 * 16
DEF BULLET_TILES_START  RB 0